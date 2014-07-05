require 'rails_helper'

describe Category do
  it { should have_many :tags }
  it { should validate_uniqueness_of(:name) }

  it { should have_valid(:name).when("!@#$%^&*()", "activity") }
  it { should_not have_valid(:name).when(nil, '') }

  it "links to tag" do
    category = FactoryGirl.create(:category)
    tag = FactoryGirl.create(:tag, category: category)
    expect(tag.category.name).to eq(category.name)
  end
end
