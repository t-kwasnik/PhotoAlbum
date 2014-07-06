require 'rails_helper'

describe PhotoTag do

  it { should_not have_valid(:photo).when(nil) }
  it { should_not have_valid(:tag).when(nil) }

  it "links to photos and tags" do
    photo = FactoryGirl.create(:photo)
    tag = FactoryGirl.create(:tag)
    photo_tag = FactoryGirl.create(:photo_tag, photo: photo, tag: tag)

    expect( photo_tag.photo ).to eq( photo )
    expect( photo_tag.tag ).to eq( tag )
  end
end
