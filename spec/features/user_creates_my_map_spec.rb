require 'rails_helper'
require "selenium-webdriver"

feature 'user creates my_map', %Q{
As a site visitor
I want to be able to group photos into a map
so I can categorize, document and share my mapped pictures
} do

# Acceptance Criteria

# I can create a my_map from my home page
# After creating a my_map I am redirected to its page
# From my home page I can see and link to all my my_maps
# I must be logged in to see a my maps by default

    user = FactoryGirl.create(:user)
    my_map = FactoryGirl.create(:my_map, user_id: user.id, name: "My First Map", description: "Description")
    my_map_photo = FactoryGirl.create_list(:my_map_photo, 5, my_map_id: my_map.id)
    my_map2 = FactoryGirl.create(:my_map, user_id: user.id, name: "My Second Map", description: "Description")
    my_map_photo = FactoryGirl.create_list(:my_map_photo, 2, my_map_id: my_map2.id)

    user2 = FactoryGirl.create(:user)
    my_map_u2 = FactoryGirl.create(:my_map, user_id: user2.id, name: "Not Mine", description: "Should not see this.")

    scenario 'home page shows all my_maps and only those that are mine', js: true do
        sign_in_as(user)
        visit photos_path
        expect(page).to have_content "My First Map"
        expect(page).to have_content "My Second Map"
        expect(page).to_not have_content "Not Mine"
    end

    scenario 'my_map accessible from home page', js: true do
        sign_in_as(user)
        visit photos_path
        click_on "My First Map"

        expect(page).to have_content "My First Map"
        expect(page).to have_content "Description"
        expect(page).to_not have_content "My Second Map"
        expect(page).to_not have_content "Should not see this."
        expect( all("img").count ).to  eq(5)
    end

    scenario 'I must be logged in to see a my_map', js: true do
        visit my_map_path(my_map.id)
        expect(page).to have_content "You need to sign in first."
    end

    scenario 'create and be redirection to a my map from home page', js: true do
        sign_in_as(user)
        visit photos_path
        fill_in "Name", with: "Cool Places"
        click_on "Create new map"

        expect(page).to have_content "Cool Places"
        expect( all(".c_map_content").count ).to  eq(0)
    end

    scenario 'map name is required to create a map' do
        sign_in_as(user)
        visit photos_path
        click_on "Create new map"
        expect(page).to have_content "Failed to create map - name can't be blank"
    end
end


