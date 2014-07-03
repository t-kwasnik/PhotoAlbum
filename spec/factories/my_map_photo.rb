FactoryGirl.define do
  factory :my_map_photo do
    sequence(:order, 100) { |n| n }
    my_map
    photo
  end
end
