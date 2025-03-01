FactoryBot.define do
  factory :borrower_term do
    association :project, factory: :project
    due_date { "2025-03-01" }
    amount_to_pay { 1000 }
  end
end
