require 'rails_helper'
require "selenium-webdriver"

feature 'user edits a my_map', %Q{
As a site visitor
edit the contents of a my_map
so I can change the names and descriptions of the map and it's photos
} do

# Acceptance Criteria

# I must be logged in to edit a my_map
# I must be able to access the edit my_map page from its show page
# I must be able to change a my_map's name and description from its edit page
# I must be able to change each my_map_photo's name and description

# On a my map's edit page I can choose to make it public
# Photos I link are linked only to the my_map and no others

    user = FactoryGirl.create( :user, email: "tester@test.com" )
    my_map = FactoryGirl.create( :my_map, user_id: user.id, name: "My Awesome Map" )
    my_map_photos = FactoryGirl.create_list( :my_map_photo, 3, my_map_id: my_map.id )

    user2 = FactoryGirl.create( :user, email: "tester2@test.com" )
    my_map2 = FactoryGirl.create( :my_map, user_id: user2.id )
    my_map_photos2 = FactoryGirl.create_list( :my_map_photo, 3, my_map_id: my_map2.id )

    scenario 'must log in to see a my_map by default', js: true do
        visit edit_my_maps_path(my_map.id)
        expect(page).to have_content "You need to sign in first."
    end

    scenario 'edit page is accessible through links from user home', js: true do
        sign_in_as(user)
        click_on "My Awesome Map"
        click_on "Edit this map"

        expect(page).to have_content "My Awesome Map"
        expect( all(".c_map_content").count ).to  eq(3)
        expect( match_url(page.find("#photo#{my_map_photos[1].id}")['src'], my_map_photos[1].image_url(:med)) ).to eq(true)
        expect( match_url(page.find("#photo#{my_map_photos[2].id}")['src'], my_map_photos[2].image_url(:med)) ).to eq(true)
        expect( match_url(page.find("#photo#{my_map_photos[3].id}")['src'], my_map_photos[3].image_url(:med)) ).to eq(true)

        expect{ page.find("#photo#{my_map_photos2[1].id}") }.to raise_error
        expect{ page.find("#photo#{my_map_photos2[2].id}") }.to raise_error
        expect{ page.find("#photo#{my_map_photos2[3].id}") }.to raise_error
        expect(page).to have_content "Save Changes"
    end

    scenario 'name and description for map and each photo are editable', js: true do
        sign_in_as(user)
        visit edit_my_maps_path(my_map.id)

        expect(page).to have_content "My Awesome Map"
        expect( all(".c_map_content").count ).to  eq(3)

        fill_in "Name", with: "My Awesomer Map"
        fill_in "Description", with: "This is a really great map, it shows the time I went somewhere"

        (1..3).each do |n|
            fill_in "Heading_#{n}", with: "Place#{n}"
            fill_in "Description_#{n}", with: "Description#{n}"
        end

        click_on "Save Changes"

        expect(page).to have_content "My Awesome Map"
        expect(page).to have_content "This is a really great map, it shows the time I went somewhere"
        (1..3).each do |n|
            expect(page).to have_content "Place#{n}"
            expect(page).to have_content "Description#{n}"
        end
    end

    scenario 'user can choose to make a map public from its page', js: true do
        sign_in_as(user)
        visit edit_my_maps_path(my_map.id)

        click_on "Make this map public"
        click_on "Sign Out"
        click_on "Save Changes"

        visit edit_my_maps_path(my_map.id)

        expect(page).to have_content "My Awesomer Map"
        expect(page).to have_content "This is a really great map, it shows the time I went somewhere"

        expect( match_url(page.find("#photo#{my_map_photos[1].id}")['src'], my_map_photos[1].image_url(:med)) ).to eq(true)
        expect( match_url(page.find("#photo#{my_map_photos[2].id}")['src'], my_map_photos[2].image_url(:med)) ).to eq(true)
        expect( match_url(page.find("#photo#{my_map_photos[3].id}")['src'], my_map_photos[3].image_url(:med)) ).to eq(true)
    end
end
