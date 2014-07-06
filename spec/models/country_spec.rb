require 'rails_helper'

describe Country do
  it { should have_valid(:name).when(name: "Country") }
  it { should_not have_valid(:name).when(nil,"") }

  it "links to photo" do
    country = FactoryGirl.create(:country)
    photo = FactoryGirl.create(:photo, country: country)
    expect(country.photos.first).to eq(photo)
  end
end
