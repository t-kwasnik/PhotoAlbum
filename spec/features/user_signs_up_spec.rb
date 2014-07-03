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

    user = FactoryGirl.create(:user)

    visit root_path
    click "Sign Up"
    fill_in "Username", with: user.username
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Confirm Password", with: user.password
    click_on "Start mapping!"

    expect(page).to have_content "Welcome #{user.username}!"
    expect(page).to have_content user.username
    expect(page).to have "Sign Out"
    expect(page).to_not have "Sign Up"
    expect(page).to_not have "Sign In"
  end


  scenario "user signs up without required information" do
    visit root_path
    click "Sign Up"

    expect(page).to have_content "Username can't be blank"
    expect(page).to have_content "Confirm Password can't be blank"
    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end

end
