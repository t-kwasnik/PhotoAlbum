require 'rails_helper'

describe PhotoTag do
  it { should belong_to :photo }
  it { should belong_to :tag }

  it { should validate_presence_of(:tag_id) }
  it { should validate_presence_of(:photo_id) }

  it { should_not have_valid(:photo_id).when(nil) }
  it { should_not have_valid(:tag_id).when(nil) }

  it "links to photos and tags" do
    pt = FactoryGirl.create(:photo_tag)

    expect(pt.photo.id).to eq(pt.photo_id)
    expect(pt.tag.id).to eq(pt.tag_id)
  end
end
