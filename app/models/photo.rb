class Photo < ActiveRecord::Base

  mount_uploader :image, PhotoUploader

  self.rgeo_factory_generator = RGeo::Geos.factory_generator

end
