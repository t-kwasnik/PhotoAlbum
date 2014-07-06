require 'rails_helper'

describe MyMapPhoto do
  it { should validate_presence_of(:order) }
  it { should validate_presence_of(:my_map) }
  it { should validate_presence_of(:photo) }


  it "links to photo and map" do
    photo = FactoryGirl.create(:photo)
    my_map = FactoryGirl.create(:my_map)
    my_map_photo = FactoryGirl.create(:my_map_photo, photo: photo, my_map: my_map)
    expect(my_map_photo.photo).to eq(photo)
    expect(my_map_photo.my_map.name).to eq(my_map.name)
  end

end
