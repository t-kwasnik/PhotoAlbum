class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :image, :city, :state, :country, :placename, :related_maps, :location

  def location
    !object.city.nil? ? city = ( object.city.name + ", " ) : ( city = "" )
    !object.state.nil? ? state = ( object.state.name + ", " ) : ( state = "" )
    !object.country.nil? ? country = ( object.country.name ) : ( country = "" )

    location = city + state + country
    location = location[0.. -3] if location[-2] == ","
    location = "Unknown" if location.gsub(",","") == ""
    location
  end
end
