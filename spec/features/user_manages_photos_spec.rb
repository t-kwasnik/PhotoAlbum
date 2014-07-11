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
# I must be able to add a selection to an existing map, after selection is added it is cleared


    user = FactoryGirl.create(:user, email: "test@tets.com")
    photo = FactoryGirl.create(:photo, user_id: user.id)
    photo2 =  FactoryGirl.create(:photo, user_id: user.id, image:  Rack::Test::UploadedFile.new( File.join(Rails.root, 'app', 'assets', 'images', 'test2.jpg'))  )
    photo3 = FactoryGirl.create(:photo, geom: nil, user_id: user.id, image:  Rack::Test::UploadedFile.new( File.join(Rails.root, 'app', 'assets', 'images', 'unmap1.jpg')) )
    user_my_map = FactoryGirl.create(:my_map, user: user, name: "My First Map")


    user2 = FactoryGirl.create(:user)
    photo4 =  FactoryGirl.create(:photo, user_id: user2.id, image:  Rack::Test::UploadedFile.new( File.join(Rails.root, 'app', 'assets', 'images', 'test2.jpg')) )
    photo5 = FactoryGirl.create(:photo, geom: nil, user_id: user2.id, image:  Rack::Test::UploadedFile.new( File.join(Rails.root, 'app', 'assets', 'images', 'unmap1.jpg')) )

    scenario 'must log in to see photos'do
        visit photos_path
        expect(page).to have_content "You need to sign in first."
    end

    scenario 'user views all of own mappable and unmappable photos', js: true do
        sign_in_as(user)

        expect( match_url(page.find("#Mapped_#{photo.id}")['src'], photo.image_url(:med)) ).to eq(true)
        expect( match_url(page.find("#Mapped_#{photo2.id}")['src'], photo2.image_url(:med)) ).to eq(true)
        expect( match_url(page.find("#Unmapped_#{photo3.id}")['src'], photo3.image_url(:med)) ).to eq(true)

        expect{ page.find("#Mapped_#{photo4.id}") }.to raise_error
        expect{ page.find("#Unmapped_#{photo5.id}") }.to raise_error
    end


    scenario 'user views information for each photo', js: true do
        sign_in_as(user)
        # clicking marker adds photo to selection ( Detail view by default )
        all(".leaflet-marker-icon")[0].trigger('click')
        expect( page ).to have_content "1 of 1"
        expect( page ).to have_content "Location"
        expect( page ).to have_content "Description"
        expect( page ).to have_content photo.placename
        expect( page ).to have_content photo.description
        expect( all(".Selection_div").count ).to eq(1)

        #double clicking does not add photo again
        all(".leaflet-marker-icon")[0].trigger('click')
        expect( page ).to have_content "1 of 1"
        expect( all(".Selection_div").count ).to eq(1)

        # adding marker does not update the selection window
        all(".leaflet-marker-icon")[1].trigger('click')
        expect( all(".Selection_div").count ).to eq(1)
        expect( page ).to have_content "1 of 2"
        expect( page ).to have_content photo.placename
        expect( page ).to have_content photo.description

        # all marker info accessible by clicking next/previous
        all("#selectionDetailNext")[0].trigger('click')
        expect( page ).to have_content "2 of 2"
        expect( page ).to have_content photo2.placename
        expect( page ).to have_content photo2.description

        all("#selectionDetailPrevious")[0].trigger('click')
        expect( page ).to have_content "1 of 2"
        expect( page ).to have_content photo.placename
        expect( page ).to have_content photo.description

        # clicking All button switches view to show all photos, switching back remembers the last photo you were looking at
        all("#selectionDetailNext")[0].trigger('click')
        click_on "All"
        expect( all(".Selection_div").count ).to eq(2)

        click_on "Detail"
        expect( page ).to have_content "2 of 2"
        expect( page ).to have_content photo2.placename
        expect( page ).to have_content photo2.description
        expect( all(".Selection_div").count ).to eq(1)
    end


    scenario 'user can make selection of one or more photos and add them to a map',js: true do
        sign_in_as(user)

        all(".leaflet-marker-icon")[0].trigger('click')
        all(".leaflet-marker-icon")[1].trigger('click')

        # all selected photos are viewable on from the All button
        click_on "All"
        expect( all(".Selection_div").count ).to eq(2)

        select "My First Map", from: "Add Selection to:"

        click_on "Add"
        sleep(5)
        # selection is cleared after adding to a map
        expect( all(".Selection_div").count ).to eq(0)

        click_on "My First Map"
        expect(page).to have_content "My First Map"
        expect( all(".c_map_content").count ).to  eq(2)
        expect( match_url(page.find("#photo#{photo.id}")['src'], photo.image_url )).to eq(true)
        expect( match_url(page.find("#photo#{photo2.id}")['src'], photo2.image_url )).to eq(true)
    end

     scenario 'user can make selection of one or more photos and add them to a map',js: true do
        sign_in_as(user)
        count = all(".leaflet-marker-icon").count
        page.attach_file "photos[]", ["#{Rails.root}/app/assets/images/test1.jpg", "#{Rails.root}/app/assets/images/test2.jpg"]
        all("#MapNewPhotos")[0].trigger('click')

        sleep(20)
        expect( all(".leaflet-marker-icon").count ).to eq( count + 2 )
    end

end

