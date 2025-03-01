FactoryBot.define do
  factory :lender_term do
    association :borrower_term, factory: :borrower_term
    association :subscription, factory: :subscription
    due_date { "2025-03-01" }
    amount_to_pay { 10 }
  end
end
