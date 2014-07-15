include ApplicationHelper

class Photo < ActiveRecord::Base

  before_save :populate_description

  belongs_to :user
  has_many :photo_tags
  has_many :tags, through: :photo_tags

  belongs_to :city
  belongs_to :state
  belongs_to :country

  has_many :my_map_photos
  has_many :my_maps, through: :my_map_photos

  validates :user, presence: true
  validates :image, presence: true

  mount_uploader :image, PhotoUploader

  self.rgeo_factory_generator = RGeo::Geos.factory_generator

  attr_reader :related_maps, :type, :geometry, :properties, :geojson, :all_tags
  attr_accessor :set_placename

  def populate_description
    if self.description.empty?
      self.description = "none"
    end
  end

  def related_maps
    @my_maps = self.my_maps.map { |obj| { name: obj["name"], id: obj["id"] } }  if self.my_maps
  end

  def all_tags
    output = { people: [], activities: [], other: [] }

    all_photo_tags = self.photo_tags
    all_photo_tags.each do |photo_tag|
      output[:people] <<  { name: photo_tag.tag.name, id: photo_tag["id"] } if photo_tag.tag.category.name == "people"
      output[:activities] <<  { name: photo_tag.tag.name, id: photo_tag["id"] } if photo_tag.tag.category.name == "activities"
      output[:other] <<  { name: photo_tag.tag.name, id: photo_tag["id"] } if photo_tag.tag.category.name == "other"
    end
    output
  end

  def activities
    @my_maps = self.tags.map { |obj| { name: obj["name"], id: obj["id"] } }  if self.my_maps
  end

  def properties
    { photo_id: self.id, image: self.image_url(:med), placename: self.placename }
  end

  def set_placename
    !self.city.nil? ? city = ( self.city.name + ", " ) : ( city = "" )
    !self.state.nil? ? state = ( self.state.name + ", " ) : ( state = "" )
    !self.country.nil? ? country = ( self.country.name ) : ( country = "" )

    location = city + state
    location += country if country != "United States"
    location = location[0.. -3] if location[-2] == ","
    location = "Unknown" if location.gsub(",","") == ""
    self.placename = location
  end


  def self.from_file( file )
    photo = Photo.new( image: file )
    photo.name = file.original_filename

    metadata = EXIFR::JPEG.new( file.tempfile )
    photo.original_date = metadata.date_time_original
    gps = metadata.gps

    if !gps.nil?
      #get lat/long
      photo.geom = "POINT(#{gps.longitude} #{gps.latitude} #{gps.altitude})"
      photo.direction = gps.image_direction

      #geocode lat/long
      url = URI.parse("http://api.tiles.mapbox.com/v3/examples.map-zr0njcqy/geocode/#{gps.longitude},#{gps.latitude}.json")
      req = Net::HTTP::Get.new( url.to_s )
      res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }

      JSON.parse(res.body)["results"].each do |results|
        results.each do |result|
          if result["type"] == "city"
            if City.where( name: result["name"] ).empty?
              photo.city = City.create( name: result["name"] )
            else
              photo.city = City.where( name: result["name"] ).first
            end
          elsif result["type"] == "province"
            if State.where( name: result["name"] ).empty?
              photo.state = State.create( name: result["name"] )
            else
              photo.state = State.where( name: result["name"] ).first
            end
          elsif result["type"] == "country"
            if Country.where( name: result["name"] ).empty?
              photo.country = Country.create( name: result["name"] )
            else
              photo.country = Country.where( name: result["name"] ).first
            end
          end
        end
        photo.set_placename
      end
    end
    return photo
  end
end
