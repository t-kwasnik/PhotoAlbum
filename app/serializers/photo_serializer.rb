class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :image, :city, :state, :country, :placename, :related_maps
end
