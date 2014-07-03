FactoryGirl.define do
  factory :state do
    sequence(:name, 100) { |n| "State #{n}" }
  end
end
