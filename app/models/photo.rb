include ApplicationHelper

class Photo < ActiveRecord::Base
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

  attr_reader :related_maps, :type, :geometry, :properties, :geojson


  def related_maps
    @my_maps = self.my_maps.map { |obj| { name: obj["name"], id: obj["id"] } }  if self.my_maps
  end

  def properties
    { photo_id: self.id, image: self.image_url(:med), placename: self.placename }
  end

end
