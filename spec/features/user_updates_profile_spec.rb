require 'rails_helper'

feature 'user edits personal information', %Q{
As a site visitor
I want to be able to update my personal information
so I can change my info
} do

# Acceptance Criteria

# I must be able to access a page with editble profile info
# I must be able to change username, email, password
# Changes I make must be saved

  scenario 'user can access and change all profile information' do

    user = FactoryGirl.create(:user)
    sign_in_as(user)

    click_on "Edit Account"

    fill_in "Username", with: "Bubba"
    fill_in "Email", with: "Bubba@gUmp.Com"
    fill_in "Password", with: "shrimp1234"
    fill_in "Confirm", with: "shrimp1234"
    fill_in "Password(Current)", with: user.password
    click_on "Update"

    expect(page).to have_content "You updated your account successfully."

    click_on "Edit Account"
    expect(page).to have_content "Bubba"
  end
end



