FactoryGirl.define do
  factory :state do
    sequence(:name) { |n| "State #{n}" }
  end
end
