require 'rails_helper'

describe User do
  it { should have_many(:photos).dependent(:destroy) }
  it { should have_many(:my_maps).dependent(:destroy) }

  it { should have_valid(:password).when("abcd1234", "asd^2jk@%#&!!") }
  it { should_not have_valid(:password).when("abcd123", nil, "") }

  it { should validate_uniqueness_of(:username) }
  it { should validate_presence_of(:username) }

  describe "#password_confirmation" do
    subject { FactoryGirl.build(:user, password: "abcd1234") }
    it { should have_valid(:password_confirmation).when("abcd1234") }
    it { should_not have_valid(:password_confirmation).when("asdasd") }
  end

  describe "#email" do
    subject { FactoryGirl.create(:user) }
    it { should have_valid(:email).when("a@aol.com", "paddington@meow.com") }
    it { should_not have_valid(:email).when("wasd", "bummer.com", "ki@", nil, "") }
    it { should validate_uniqueness_of(:email) }
  end

  it "links to photos and my_maps" do
    user = FactoryGirl.create(:user)
    FactoryGirl.create_list(:photo, 3, user: user)
    FactoryGirl.create_list(:my_map, 3, user: user)

    expect(user.photos.length).to eq(3)
    expect(user.my_maps.length).to eq(3)
  end
end
