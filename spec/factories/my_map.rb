FactoryGirl.define do
  factory :my_map do
    sequence( :name ) { |n| "Album #{n}" }
    user

    factory :map_with_photos do

      ignore { photos_count 5 }

      after(:create) do |my_map, evaluator|
        photos = create_list(:photo, evaluator.photos_count , user: my_map.user )
        photos.each do |photo|
          create( :my_map_photo, my_map: my_map, photo: photo )
        end
      end
    end
  end
end
