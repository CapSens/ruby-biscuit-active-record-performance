class CreateLenderTermsBefore
  attr_reader :project

  def initialize(project)
    @project = project
  end

  def call
    destroy_lender_terms!
    create_lender_terms!
  end

  def destroy_lender_terms!
    project.borrower_terms.each do |borrower_term|
      borrower_term.lender_terms.destroy_all
    end
  end

  def create_lender_terms!
    borrower_terms = project.borrower_terms
    subscriptions_count = project.subscriptions.size

    project.subscriptions.find_each do |subscription|
      previous_investor_term = subscription.lender_terms.last
      current_investor_term = nil

      borrower_terms.find_each do |borrower_term|
        # This should be a ratio but we are not going to implement this in this script
        attributes = { amount_to_pay: borrower_term.amount_to_pay / subscriptions_count }

        current_investor_term = subscription.lender_terms.build(
          attributes.merge(
            due_date: borrower_term.due_date,
            borrower_term: borrower_term
          )
        )

        current_investor_term.save!

        previous_investor_term = current_investor_term
      end
    end
  end
end
