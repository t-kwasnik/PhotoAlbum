class RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json

  def create
    user = User.new(user_params)
    response = { valid_username: false, valid_email: false, valid_password: false, valid_confirm: false }

    response[:valid_username] = true if User.where( username: user[:username] ).empty?
    response[:valid_email] = true if User.where( email: user[:email] ).empty?
    response[:valid_password] = true if user_params["password"].length >= 8
    response[:valid_confirm] = true if user_params["password"] == user_params["password_confirmation"]

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
