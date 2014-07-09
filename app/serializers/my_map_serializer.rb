class MyMapSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :photos

  def photos
    MyMap.find(object).my_map_photos.order(:order)
  end
end
