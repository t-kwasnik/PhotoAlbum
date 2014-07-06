FactoryGirl.define do
  sequence(:name) { |n| "Album #{n}" }

  factory :my_map do
    name
    user
  end

end
