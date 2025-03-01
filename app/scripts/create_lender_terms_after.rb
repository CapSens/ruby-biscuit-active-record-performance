class CreateLenderTermsAfter
  attr_reader :project

  def initialize(project)
    @project = project
  end

  def call
    destroy_lender_terms!
    create_lender_terms!
  end

  def destroy_lender_terms!
    LenderTerm.where(borrower_term_id: project.borrower_terms.ids).delete_all
  end

  def create_lender_terms!
    borrower_terms = project.borrower_terms
    subscriptions_count = project.subscriptions.size
    lender_terms_attributes = []

    # n+1 évité
    project.subscriptions.includes(:lender_terms).find_each do |subscription|
      previous_investor_term = subscription.lender_terms.last
      current_investor_term = nil

      # find_each non nécessaire, on réutilise les même échéances emprunteurs pour chaque souscription
      # on se retrouvait à faire autant de requêtes en plus que de souscriptions inutilement
      borrower_terms.each do |borrower_term|
        # This should be a ratio but we are not going to implement this in this script
        attributes = { amount_to_pay: borrower_term.amount_to_pay / subscriptions_count }

        # On le build quand même car on en a besoin pour définir les attributs de la prochaine échéance
        current_investor_term = LenderTerm.new(
          attributes.merge!(
            due_date: borrower_term.due_date,
            borrower_term_id: borrower_term.id,
            subscription_id: subscription.id
          )
        )

        lender_terms_attributes.push(attributes)

        previous_investor_term = current_investor_term
      end
    end

    # une requête SQL pour tout créer
    LenderTerm.import!(lender_terms_attributes)
  end
end
