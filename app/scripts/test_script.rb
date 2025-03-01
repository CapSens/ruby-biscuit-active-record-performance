class TestScript
  # script de test simplifié
  def self.benchmark_time(subscriptions_count, project_duration)
    ActiveRecord::Base.transaction do
      puts ("Initialisation des objets")
      project = init_objects(subscriptions_count, project_duration)
      puts "Done - Lender terms : #{LenderTerm.count}"

      log_execution_time("Nouveau générateur") do
        CreateLenderTermsAfter.new(project).call
      end

      puts "Done - Lender terms : #{LenderTerm.count}"

      raise ActiveRecord::Rollback
    end

    puts "\n----\n\n"

    ActiveRecord::Base.transaction do
      puts ("Initialisation des objets")
      project = init_objects(subscriptions_count, project_duration)
      puts "Done - Lender terms : #{LenderTerm.count}"

      log_execution_time("Ancien générateur") do
        CreateLenderTermsBefore.new(project).call
      end

      puts "Done - Lender terms : #{LenderTerm.count}"

      raise ActiveRecord::Rollback
    end
  end

  def self.benchmark_memory(subscriptions_count, project_duration)
    Benchmark.memory do |x|
      x.report("Nouveau générateur") do
        ActiveRecord::Base.transaction do
          project = init_objects(subscriptions_count, project_duration)
          CreateLenderTermsAfter.new(project).call
          raise ActiveRecord::Rollback
        end
      end

      x.report("Ancien générateur") do
        ActiveRecord::Base.transaction do
          project = init_objects(subscriptions_count, project_duration)
          CreateLenderTermsBefore.new(project).call
          raise ActiveRecord::Rollback
        end
      end

    end
  end

  def self.init_objects(subscriptions_count, project_duration)
    project = FactoryBot.create(:project, :with_borrower_terms, terms_count: project_duration)
    user = FactoryBot.create(:user)
    borrower_terms_ids = project.borrower_terms.ids

    subscriptions_hash = [*1..subscriptions_count].map do
      {
        project_id: project.id,
        user_id: user.id,
        amount: rand(500.1200)
      }
    end

    Subscription.import!(subscriptions_hash)

    lender_terms_hash = Subscription.ids.map do |subscription_id|
      {
        subscription_id: subscription_id,
        borrower_term_id: borrower_terms_ids.sample,
        amount_to_pay: rand(50.120)
      }
    end

    LenderTerm.import!(lender_terms_hash)

    project
  end

  def self.log_execution_time(message = "Temps d'exécution")
    start_time = Time.now        # On enregistre l'heure de début
    result = yield               # On exécute le bloc passé à la méthode
    end_time = Time.now          # On enregistre l'heure de fin

    # Calcul de la durée en millisecondes et affichage
    duration_ms = ((end_time - start_time) * 1000).round(2)
    puts "#{message} : #{duration_ms} ms"

    result                       # On retourne le résultat du bloc
  end
end
