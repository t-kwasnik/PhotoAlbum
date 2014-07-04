module ApplicationHelper

  def geoJSON(geometry, properties)
    if geometry
      factory = RGeo::GeoJSON::EntityFactory.instance
      feature = factory.feature(geometry, nil, properties)
      output = RGeo::GeoJSON.encode(feature)
    else
      output = { type: "Unmapped", geometry: "", properties: properties }
    end
    output
  end

  def authenticate
    if current_user.nil?
      flash[:notice] = "You need to sign in first."
      redirect_to main_index_path
    end
  end

end
