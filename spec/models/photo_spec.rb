require 'rails_helper'

describe Photo do
  it { should belong_to :user }
  it { should belong_to :city }
  it { should belong_to :state }
  it { should belong_to :country }
  it { should have_many :photo_tags }
  it { should have_many :my_map_photos }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:image) }


  it { should_not have_valid(:user_id).when(nil) }

  it "sets is_public to false by default" do
    user = FactoryGirl.create(:user)
    expect(Photo.create(user_id: user)[:is_public]).to eq(false)
  end

  it "links to places" do
    p = FactoryGirl.create(:photo)
    expect(p.city.name).to_not eq(nil)
    expect(p.state.name).to_not eq(nil)
    expect(p.country.name).to_not eq(nil)
  end

  it "links to user" do
    p = FactoryGirl.create(:photo)
    expect(p.user.id).to_not eq(nil)
  end

  it "links to my_map" do
    p = FactoryGirl.create(:photo)
    mm = FactoryGirl.create(:my_map)
    mmp = FactoryGirl.create(:my_map_photo, photo_id: p.id, my_map_id: mm.id)

    expect(p.my_maps.first.id).to eq(mm.id)
    expect(p.my_map_photos.first.id).to eq(mmp.id)
  end

  it "links to tags" do
    p = FactoryGirl.create(:photo, user_id: 1)
    t = FactoryGirl.create(:tag)
    pt = FactoryGirl.create(:photo_tag, photo_id: p.id, tag_id: t.id)

    expect(p.tags.first.id).to eq(t.id)
    expect(p.photo_tags.first.id).to eq(pt.id)
  end
end

