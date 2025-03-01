FactoryBot.define do
  factory :user do
    email { "test@test.com" }
    first_name { "toto" }
    last_name { "titi" }
  end
end
