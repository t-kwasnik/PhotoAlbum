require 'rails_helper'

describe Tag do
  it { should have_valid(:name).when("My Awesome Tag") }
  it { should_not have_valid(:name).when(nil, "") }
  it { should validate_presence_of(:category) }

  it "links to photos" do
    tag = FactoryGirl.create(:tag)
    photo_tag =  FactoryGirl.create(:photo_tag, tag: tag )

    expect(tag.photos.last).to eq(photo_tag.photo)
    expect(tag.photo_tags.last).to eq(photo_tag)
  end

end
