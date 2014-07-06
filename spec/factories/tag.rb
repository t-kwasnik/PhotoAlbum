FactoryGirl.define do
  factory :tag do
    sequence( :name ) { |n| "Tag #{n}" }
    category
  end
end
