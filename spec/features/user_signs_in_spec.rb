require 'rails_helper'

feature 'user signs in', %Q{
As a site visitor
I want to be able to sign in
so I can get to my main page
} do

# Acceptance Criteria

# I must provide username or email, and valid password
# I must be able to access sign in from main page
# Once signed in I must be able sign out

  scenario 'user signs in from main page with email' do

    user = FactoryGirl.create(:user)

    visit root_path
    click_on "Sign In"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Sign in"

    expect(page).to have_content "Signed in successfully."
    expect(page).to have_content user.username
    expect(page).to have_content "Sign Out"
    expect(page).to_not have_content "Sign Up"
    expect(page).to_not have_content "Sign In"
  end

  scenario 'user signs in without credentials' do
    visit root_path
    click_on "Sign In"
    click_on "Sign in"

    expect(page).to have_content "Invalid email or password."
  end


  scenario 'user signs in with invalid password' do
    user = FactoryGirl.create(:user)
    visit root_path
    click_on "Sign In"
    fill_in "Email", with: user.email
    fill_in "Password", with: "Apple"
    click_on "Sign in"

    expect(page).to have_content "Invalid email or password."
  end

  scenario 'user signs in with invalid username/email' do
    user = FactoryGirl.create(:user)
    visit root_path
    click_on "Sign In"
    fill_in "Email", with: "Apple"
    fill_in "Password", with: user.password
    click_on "Sign in"

    expect(page).to have_content "Invalid email or password."
  end
end
