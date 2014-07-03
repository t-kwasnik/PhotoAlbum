require 'rails_helper'

describe User do
  it { should have_many(:photos).dependent(:destroy) }
  it { should have_many(:my_maps).dependent(:destroy) }

  it { should have_valid(:password).when("abcd1234", "asd^2jk@%#&!!") }
  it { should_not have_valid(:password).when("abcd123", nil, "") }

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
    it { should validate_uniqueness_of(:username) }
  end

  it { should validate_uniqueness_of(:username) }
  it { should validate_presence_of(:username) }

  it "links to photos" do
    u = FactoryGirl.create(:user)
    FactoryGirl.create_list(:photo, 3, user_id: u.id)

    expect(u.photos.length).to eq(3)
  end
end
