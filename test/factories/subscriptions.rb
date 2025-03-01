FactoryBot.define do
  factory :subscription do
    association :project, factory: :project
    association :user, factory: :user
    amount { 100 }
  end
end
