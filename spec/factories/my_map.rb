FactoryGirl.define do
  factory :my_map do
    sequence(:name, 100) { |n| "Album #{n}" }
    user
  end
end
