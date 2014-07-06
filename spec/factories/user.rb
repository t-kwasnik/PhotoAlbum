FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password '1234abcd'
    sequence(:username) { |n| "person#{n}" }
    is_admin false

    trait :admin do
      is_admin true
    end

    factory :admin, traits: [:admin]
  end
end
