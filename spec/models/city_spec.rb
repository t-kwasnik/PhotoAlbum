require 'rails_helper'

describe City do
  it { should have_many :photos }

  it { should have_valid(:name).when("City") }
  it { should_not have_valid(:name).when(nil, '') }

  it "links to photo" do
    city = FactoryGirl.create(:city)
    photo = FactoryGirl.create(:photo, city: city)
    expect(photo.city.name).to eq(city.name)
  end
end
