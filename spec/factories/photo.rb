FactoryGirl.define do
  factory :photo do
    sequence(:my_description, 100) { |n| "description " * n }
    sequence(:placename, 100) { |n| "placename #{n}" }
    user
    city
    state
    country
  end
end
