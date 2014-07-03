FactoryGirl.define do
  factory :country do
    sequence(:name, 100) { |n| "Country #{n}" }
  end
end
