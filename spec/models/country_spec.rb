require 'rails_helper'

describe Country do
  it { should have_many :photos }
  it { should have_valid(:name).when(name: "Country") }
  it { should_not have_valid(:name).when(nil) }
  it { should validate_presence_of(:name) }

  it "links to photo" do
    c = FactoryGirl.create(:country)
    photo = FactoryGirl.create(:photo, country_id: c.id)
    expect(photo.country.name).to eq(c.name)
  end
end
