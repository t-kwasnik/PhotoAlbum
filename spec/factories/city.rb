FactoryGirl.define do
  factory :city do
    sequence(:name, 100) { |n| "City #{n}" }
  end
end
