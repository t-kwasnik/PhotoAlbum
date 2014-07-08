require 'rails_helper'

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

    scenario 'must log in to see a my_map by default' do
        visit edit_my_map_path(my_map.id)
        expect(page).to have_content "You need to sign in first."
    end

    scenario 'edit page is accessible through links from user home' do
        sign_in_as(user)
        click_on "My Awesome Map"
        click_on "Edit this map."

        find_field("Name").value.should eq "My Awesome Map"
        expect( all(".c_map_content").count ).to  eq(3)

        expect( match_url(page.find("#photo#{my_map_photos[1].id}")['src'], my_map_photos[1].photo.image_url )).to eq(true)
        expect( match_url(page.find("#photo#{my_map_photos[2].id}")['src'], my_map_photos[2].photo.image_url )).to eq(true)
        expect( match_url(page.find("#photo#{my_map_photos[0].id}")['src'], my_map_photos[0].photo.image_url )).to eq(true)

        expect{ page.find("#photo#{my_map_photos2[1].id}") }.to raise_error
        expect{ page.find("#photo#{my_map_photos2[2].id}") }.to raise_error
        expect{ page.find("#photo#{my_map_photos2[0].id}") }.to raise_error
        expect(page).to have_content "Done with Changes"
    end

    scenario 'name and description for map and each photo are editable' do
        sign_in_as(user)
        visit edit_my_map_path(my_map.id)

        find_field("Name").value.should eq "My Awesome Map"
        expect( all(".c_map_content").count ).to  eq(3)

        (0..3).each do |n|
            if n == 0
                fill_in "Name", with: "Title#{n}"
                fill_in "Description", with: "This is a really great thing#{n}"
                click_on "Save_Heading"
                find_field("Name").value.should eq "Title#{n}"
                find_field("Description").value.should eq "This is a really great thing#{n}"
            else
                fill_in "Heading#{n}", with: "Title#{n}"
                fill_in "Description#{n}", with: "This is a really great thing#{n}"
                click_on "Save_Entry#{n}"
                find_field("Heading#{n}").value.should eq "Title#{n}"
                find_field("Description#{n}").value.should eq "This is a really great thing#{n}"
            end
        end

        visit my_map_path(my_map.id)

        (0..3).each do |n|
            expect(page).to have_content "Title#{n}"
            expect(page).to have_content "This is a really great thing#{n}"
        end
    end

    scenario 'user can choose to make a map public from its page' do
        sign_in_as(user)
        visit edit_my_map_path(my_map.id)

        check "Make this map public"
        click_on "Save_Heading"
        click_on "Sign Out"

        visit my_map_path(my_map.id)

        expect(page).to have_content my_map.name
        expect(page).to_not have_content "Edit this map."

        expect( match_url(page.find("#photo#{my_map_photos[1].photo.id}")['src'], my_map_photos[1].photo.image_url )).to eq(true)
        expect( match_url(page.find("#photo#{my_map_photos[2].photo.id}")['src'], my_map_photos[2].photo.image_url )).to eq(true)
        expect( match_url(page.find("#photo#{my_map_photos[0].photo.id}")['src'], my_map_photos[0].photo.image_url )).to eq(true)
    end
end
