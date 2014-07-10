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


end
