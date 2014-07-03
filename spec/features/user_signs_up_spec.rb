require 'rails_helper'

feature 'user signs up', %Q{
As a site visitor
I want to be able to sign up
so I can create an account and go to my main page
} do

# Acceptance Criteria

# I must provide username, email, password and confirmation password
# I must be able to access sign up from main page
# Once signed in I must be able sign out

  scenario 'user signs up from main page' do

    visit root_path
    click_on "Sign Up"
    fill_in "Username", with: "Bubba"
    fill_in "Email", with: "Bubba@gUmp.Com"
    fill_in "Password", with: "shrimp1234"
    fill_in "Confirm", with: "shrimp1234"
    click_on "Start mapping!"

    expect(page).to have_content "Welcome!"
    expect(page).to have_content "Bubba"
    expect(page).to have_content "Sign Out"
    expect(page).to_not have_content "Sign Up"
    expect(page).to_not have_content "Sign In"
  end

  scenario 'user cant signs up with existing username' do

    user = FactoryGirl.create(:user)

    visit root_path
    click_on "Sign Up"
    fill_in "Username", with: user.username
    fill_in "Email", with: "Bubba@gUmp.Com"
    fill_in "Password", with: "shrimp1234"
    fill_in "Confirm", with: "shrimp1234"
    click_on "Start mapping!"

    expect(page).to have_content "already been taken"
  end

scenario 'user cant signs up with existing username' do

    user = FactoryGirl.create(:user)

    visit root_path
    click_on "Sign Up"
    fill_in "Username", with: "Bubba"
    fill_in "Email", with: user.email
    fill_in "Password", with: "shrimp1234"
    fill_in "Confirm", with: "shrimp1234"
    click_on "Start mapping!"

    expect(page).to have_content "already been taken"
  end


  scenario "user signs up without required information" do

    visit root_path
    click_on "Sign Up"
    click_on "Start mapping!"

    expect(page).to have_content "can't be blank"
  end

end
