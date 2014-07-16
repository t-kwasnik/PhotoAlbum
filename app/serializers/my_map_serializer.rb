class MyMapSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :photos

  def photos
    photos =  MyMap.find( object ).photos
    photos.map { |photo| { id: photo.id, image: photo.image_url(:med) }}
  end
end
