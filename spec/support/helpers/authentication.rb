module Helpers
  module Authentication
    def sign_in_as(user)
      visit new_user_session_path
      fill_in "Username/Email", with: user.email
      fill_in "Password", with: user.password
      click_on "Sign in"
    end
  end
end
