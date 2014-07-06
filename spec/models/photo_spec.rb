require 'rails_helper'

describe Photo do
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:image) }

  it { should_not have_valid(:user).when(nil) }
  it { should_not have_valid(:image).when(nil) }

  it "sets is_public to false by default" do
    user = FactoryGirl.create(:user)
    expect(Photo.create(user: user)[:is_public]).to eq(false)
  end

  it "links to places" do
    city = FactoryGirl.create(:city)
    state = FactoryGirl.create(:state)
    country = FactoryGirl.create(:country)
    user = FactoryGirl.create(:user)

    photo = FactoryGirl.create(:photo, city: city, state: state, country: country, user: user)

    expect(photo.city.name).to eq(city.name)
    expect(photo.state.name).to eq(state.name)
    expect(photo.country.name).to eq(country.name)
    expect(photo.user).to eq(user)
  end

  it "linkable to my_map" do
    photo = FactoryGirl.create(:photo)
    my_map = FactoryGirl.create(:my_map)
    my_map_photo = FactoryGirl.create(:my_map_photo, photo: photo, my_map: my_map)

    expect(photo.my_maps.first).to eq(my_map)
    expect(photo.my_map_photos.first).to eq(my_map_photo)
  end

  it "links to tags" do
    photo = FactoryGirl.create(:photo, user_id: 1)
    tag = FactoryGirl.create(:tag)
    photo_tag = FactoryGirl.create(:photo_tag, photo: photo, tag: tag)

    expect(photo.tags.first).to eq(tag)
    expect(photo.photo_tags.first).to eq(photo_tag)
  end
end

