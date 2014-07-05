FactoryGirl.define do
  factory :user do
    sequence(:email, 1000) { |n| "person#{n}@example.com" }
    password '1234abcd'
    sequence(:username, 100) { |n| "person#{n}" }
    is_admin false

    trait :admin do
      is_admin true
    end

    factory :admin, traits: [:admin]
  end
end
