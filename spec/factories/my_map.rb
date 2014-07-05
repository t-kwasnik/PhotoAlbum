FactoryGirl.define do
  sequence(:name, 100) { |n| "Album #{n}" }

  factory :my_map do
    name
    user
  end

end
