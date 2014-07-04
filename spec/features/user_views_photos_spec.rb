require 'rails_helper'
require "selenium-webdriver"

feature 'user views photos', %Q{
As a site visitor
I want to be able to view all my photos
so I can manage them
} do

# Acceptance Criteria

# I must be able to view all mapped and unmapped photos in a scroll bar
# I must be able to view all photos placed on a map
# I must be logged in to see my photos

    user = FactoryGirl.create(:user)
    photo = FactoryGirl.create(:photo, user_id: user.id)
    photo2 =  FactoryGirl.create(:photo, user_id: user.id, image:  Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images', 'test2.jpg'))  )
    photo3 = FactoryGirl.create(:photo, geom: nil, user_id: user.id, image:  Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images', 'unmap1.jpg')) )

    user2 = FactoryGirl.create(:user)
    photo4 =  FactoryGirl.create(:photo, user_id: user2.id, image:  Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images', 'test2.jpg')) )
    photo5 = FactoryGirl.create(:photo, geom: nil, user_id: user2.id, image:  Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images', 'unmap1.jpg')) )

    scenario 'must log in to see photos', js: true do
        visit photos_path
        expect(page).to have_content "You need to sign in first."
    end

    scenario 'user views all of own mappable photos', js: true do
        sign_in_as(user)

        expect( match_url(page.find("#photo#{photo.id}")['src'], photo.image_url(:med)) ).to eq(true)
        expect( match_url(page.find("#photo#{photo2.id}")['src'], photo2.image_url(:med)) ).to eq(true)
        expect( match_url(page.find("#photo#{photo3.id}")['src'], photo2.image_url(:med)) ).to eq(true)
    end

    scenario 'user views only own mappable photos', js: true do
        sign_in_as(user)

        expect{ page.find("#photo#{photo4.id}") }.to raise_error
    end

    scenario 'user views only own unmappable photos', js: true do
        sign_in_as(user)

        expect( match_url(page.find("#photo#{photo3.id}")['src'], photo.image_url(:med)) ).to eq(true)
        expect{ page.find("#photo#{photo5.id}") }.to raise_error
    end
end

