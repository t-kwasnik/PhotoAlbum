require 'rails_helper'

describe MyMap do
  it { should belong_to :user }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:name) }

  it { should have_valid(:name).when("My Awesome Map") }
  it { should_not have_valid(:name).when(nil) }

  it { should_not have_valid(:user_id).when(nil) }

  it "sets is_public to false by default" do
    user = FactoryGirl.create(:user)
    expect(MyMap.create(user_id: user, name: "Map 1")[:is_public]).to eq(false)
  end

  it "links to user" do
    mm = FactoryGirl.create(:my_map)
    expect(mm.user.id).to_not eq(nil)
  end

  it "links to photos" do
    mm = FactoryGirl.create(:my_map)
    FactoryGirl.create_list(:my_map_photo, 2, my_map_id: mm.id)

    expect(mm.photos.length).to eq(2)
  end
end
