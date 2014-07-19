module ApplicationHelper

  def authenticate
    if current_user.nil?
      flash[:notice] = "You need to sign in first."
      redirect_to main_index_path
    end
  end

  def has_geom(feature)
    if feature.geom
      true
    else
      false
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
   @devise_mapping ||= Devise.mappings[:user]
  end

end
