class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :image, :placename, :related_maps

  def description
    description = object.description
    description = " " if object.description.nil?
    description
  end
end
