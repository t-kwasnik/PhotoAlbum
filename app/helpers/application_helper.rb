module ApplicationHelper

  def geoJSON(geometry, properties)
    factory = RGeo::GeoJSON::EntityFactory.instance
    feature = factory.feature(geometry, nil, properties)
    output = RGeo::GeoJSON.encode(feature)
    output
  end

end
