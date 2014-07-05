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

  def compile_my_map(id)
    my_map = MyMap.find(id)
    my_map_hash = JSON.parse(my_map.to_json)
    my_map_hash["photos"] = my_map.my_map_photos.order(:order)
    my_map_hash
  end

  def authenticate
    if current_user.nil?
      flash[:notice] = "You need to sign in first."
      redirect_to main_index_path
    end
  end

  def public_map_check
    begin
      authenticate if !MyMap.find(params[:id]).is_public
    rescue
      redirect_to root_path
    end
  end

end
