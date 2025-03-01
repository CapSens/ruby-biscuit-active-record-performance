FactoryBot.define do
  factory :project do
    name { "MyString" }

    trait :with_borrower_terms do
      transient do
        terms_count { 20 }
      end

      after(:create) do |project, evaluator|
        create_list(:borrower_term, evaluator.terms_count, project: project)
      end
    end
  end
end
