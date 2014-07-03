require 'rails_helper'

describe Tag do
  it { should have_many :photo_tags }
  it { should belong_to :category }

  it { should validate_presence_of(:category_id) }
  it { should validate_presence_of(:name) }

  it { should have_valid(:name).when("My Awesome Tag") }
  it { should_not have_valid(:name).when(nil) }

  it "links to photos" do
    t = FactoryGirl.create(:tag)
    pt =  FactoryGirl.create(:photo_tag, tag_id: t.id )

    expect(t.photos.length).to eq(1)
    expect(t.photo_tags.length).to eq(1)
  end

end
