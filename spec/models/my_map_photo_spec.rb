require 'rails_helper'

describe MyMapPhoto do
  it { should belong_to :photo }
  it { should belong_to :my_map }

  it { should validate_presence_of(:my_map_id) }
  it { should validate_presence_of(:photo_id) }
  it { should validate_presence_of(:order) }

  it { should have_valid(:order).when(1) }
  it { should_not have_valid(:order).when(nil) }

  it { should_not have_valid(:photo_id).when(nil) }
  it { should_not have_valid(:my_map_id).when(nil) }

  it "links to photo and map" do
    mmp = FactoryGirl.create(:my_map_photo)

    expect(mmp.photo.id).to_not eq(nil)
    expect(mmp.my_map.id).to_not eq(nil)
  end

end
