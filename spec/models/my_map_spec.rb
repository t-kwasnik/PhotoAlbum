require 'rails_helper'

describe MyMap do
  it { should have_valid(:name).when("My Awesome Map") }
  it { should_not have_valid(:name).when(nil) }
  it { should_not have_valid(:user).when(nil) }

  it "sets is_public to false by default" do
    user = FactoryGirl.create(:user)
    expect(MyMap.create(user: user, name: "Map 1")[:is_public]).to eq(false)
  end

  it "links to user" do
    user = FactoryGirl.create(:user)
    my_map = FactoryGirl.create(:my_map, user: user)
    expect(my_map.user).to eq(user)
  end

  it "links to photos" do
    my_map = FactoryGirl.create(:map_with_photos, photos_count: 5)
    expect(my_map.photos.length).to eq(5)
  end
end
