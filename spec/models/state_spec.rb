require 'rails_helper'

describe State do
  it { should have_valid(:name).when("City") }
  it { should_not have_valid(:name).when(nil) }

  it "links to photo" do
    state = FactoryGirl.create(:state)
    photo = FactoryGirl.create(:photo, state: state)
    expect(state.photos.first).to eq(photo)
  end
end
