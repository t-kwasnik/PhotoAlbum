require 'rails_helper'

feature 'user signs out', %Q{
As a site visitor
I want to be able to sign in
so I can get to my main page
} do

# Acceptance Criteria

# I must provide username or email, and valid password
# I must be able to access sign in from main page
# Once signed out I must be able to sign in

scenario "user signs out" do
  user = FactoryGirl.create(:user)
  sign_in_as(user)

  click_on "Sign Out"

  expect(page).to have_content "Signed out successfully."
  expect(page).to_not have_content "Sign Out"
  expect(page).to have_content "Sign Up"
  expect(page).to have_content "Sign In"
end

end
