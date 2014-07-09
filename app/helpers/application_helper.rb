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

  def type
    if has_geom(object)
      "Feature"
    else
      "Unmapped"
    end
  end


  def geometry
    if has_geom(object)
      { type: "Point", coordinates: [ object.geom.y, object.geom.x, object.geom.z]}
    else
      ""
    end
  end

end
