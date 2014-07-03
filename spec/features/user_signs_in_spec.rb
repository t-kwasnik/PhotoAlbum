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

  scenario 'user signs in from main page with username' do

    user = FactoryGirl.create(:user)

    visit root_path
    click "Sign In"
    fill_in "Username/Email", with: user.username
    fill_in "Password", with: user.password
    click_on "Sign in"

    expect(page).to have_content user.username
    expect(page).to have "Sign Out"
    expect(page).to_not have "Sign Up"
    expect(page).to_not have "Sign In"
  end

  scenario 'user signs in from main page with email' do

    user = FactoryGirl.create(:user)

    visit root_path
    click "Sign In"
    fill_in "Username/Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Sign in"

    expect(page).to have_content user.username
    expect(page).to have "Sign Out"
    expect(page).to_not have "Sign Up"
    expect(page).to_not have "Sign In"
  end

  scenario 'user signs in without credentials' do
    visit root_path
    click "Sign In"
    click_on "Sign in"

    expect(page).to have_content "can't be blank"
  end


  scenario 'user signs in with invalid password' do
    visit root_path
    click "Sign In"
    fill_in "Username/Email", with: user.email
    fill_in "Password", with: "Apple"
    click_on "Sign in"

    expect(page).to have_content "invalid login credentials"
  end

  scenario 'user signs in with invalid username/email' do
    visit root_path
    click "Sign In"
    fill_in "Username/Email", with: "Apple"
    fill_in "Password", with: user.password
    click_on "Sign in"

    expect(page).to have_content "invalid login credentials"
  end
end
