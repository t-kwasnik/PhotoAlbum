class PhotoQuickDetailSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :is_public, :placename

  def description
    description = object.description
    description = " " if object.description.nil?
    description
  end

end
