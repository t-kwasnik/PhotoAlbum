require 'rails_helper'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist_debug

feature 'user manages photos', %Q{
As a site visitor
I want to be able to view and select all my photos
so I can manage them
} do

# Acceptance Criteria

# I must be able to view all mapped and unmapped photos in a scroll bar
# I must be able to view all photos placed on a map
# I must be logged in to see my photos
# I must be able to add photos to a selection
# I must be able to add a selection to an existing map


    user = FactoryGirl.create(:user, email: "test@tets.com")
    photo = FactoryGirl.create(:photo, user_id: user.id)
    photo2 =  FactoryGirl.create(:photo, user_id: user.id, image:  Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images', 'test2.jpg'))  )
    photo3 = FactoryGirl.create(:photo, geom: nil, user_id: user.id, image:  Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images', 'unmap1.jpg')) )
    user_my_map = FactoryGirl.create(:my_map, user: user, name: "My First Map")


    user2 = FactoryGirl.create(:user)
    photo4 =  FactoryGirl.create(:photo, user_id: user2.id, image:  Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images', 'test2.jpg')) )
    photo5 = FactoryGirl.create(:photo, geom: nil, user_id: user2.id, image:  Rack::Test::UploadedFile.new(File.join(Rails.root, 'app', 'assets', 'images', 'unmap1.jpg')) )

    scenario 'must log in to see photos'do
        visit photos_path
        expect(page).to have_content "You need to sign in first."
    end

    scenario 'user views all of own mappable and unmappable photos', js: true do
        sign_in_as(user)

        expect( match_url(page.find("#photo#{photo.id}")['src'], photo.image_url(:med)) ).to eq(true)
        expect( match_url(page.find("#photo#{photo2.id}")['src'], photo2.image_url(:med)) ).to eq(true)
        expect( match_url(page.find("#photo#{photo3.id}")['src'], photo3.image_url(:med)) ).to eq(true)

        expect{ page.find("#photo#{photo4.id}") }.to raise_error
        expect{ page.find("#photo#{photo5.id}") }.to raise_error
    end

    scenario 'user can make selection of one or more photos and add them to a map',js: true do
        sign_in_as(user)

        markers = all(".leaflet-marker-icon")

        markers[0].trigger('click')
        expect( all(".selected_photo_div").count ).to eq(1)

        markers = all(".leaflet-marker-icon")
        markers[1].trigger('click')

        expect( all(".selected_photo_div").count ).to eq(2)

        select "My First Map", from: "Add Selection to:"

        click_on "Add"
        sleep(5)

        click_on "My First Map"
        expect(page).to have_content "My First Map"
        expect( all(".c_map_content").count ).to  eq(2)
        expect( match_url(page.find("#photo#{photo.id}")['src'], photo.image_url )).to eq(true)
        expect( match_url(page.find("#photo#{photo2.id}")['src'], photo2.image_url )).to eq(true)
    end
end

