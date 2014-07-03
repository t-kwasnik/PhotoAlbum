require 'rails_helper'

describe Category do
  it { should have_many :tags }
  it { should validate_uniqueness_of(:name) }

  it { should have_valid(:name).when("!@#$%^&*()") }
  it { should have_valid(:name).when("activity") }
  it { should_not have_valid(:name).when(nil) }
  it { should validate_presence_of(:name) }

  it "links to tag" do
    c = FactoryGirl.create(:category)
    tag = FactoryGirl.create(:tag, category_id: c.id)
    expect(tag.category.name).to eq(c.name)
  end
end
