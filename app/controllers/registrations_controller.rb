class RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json

  def create
    user = User.new(user_params)
    response = { user_username: false, user_email: false, user_password: false }

    response[:user_username] = true if user.valid_new_username
    response[:user_email] = true if user.valid_new_email

    if user_params["password"]
      response[:user_password] = true if user_params["password"].length > 7
    end

    all_valid = true
    response.each do |key, value|
      if value == false
        all_valid = false
        break
      end
    end

    if all_valid == false
      respond_to do |format|
        format.html { render json: response }
      end
    else
      if user.save
        sign_in(:user, user)
      end

      redirect_to root_path
    end

  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def user_params
    params.required(:user).permit(:username, :email, :password, :password_confirmation, :image, :phone_number )
  end

end
