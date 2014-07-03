require 'rails_helper'

describe State do
  it { should have_many :photos }
  it { should have_valid(:name).when("City") }
  it { should_not have_valid(:name).when(nil) }

  it { should validate_presence_of(:name) }

  it "links to photo" do
    c = FactoryGirl.create(:state)
    photo = FactoryGirl.create(:photo, state_id: c.id)
    expect(photo.state.name).to eq(c.name)
  end
end
