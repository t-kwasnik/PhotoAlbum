FactoryGirl.define do
  factory :tag do
    sequence(:name, 100) { |n| "Tag #{n + 1}" }
    category
  end
end
