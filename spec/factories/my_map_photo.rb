FactoryGirl.define do
  factory :my_map_photo do
    sequence( :order ) { |n| n }
    my_map
    photo
  end
end
