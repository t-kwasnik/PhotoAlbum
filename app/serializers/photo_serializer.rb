class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :image, :placename, :related_maps, :people, :activities, :tags

  def description
    description = object.description
    description = " " if object.description.nil?
    description
  end

  def people
    people = Category.where(name: "people")
    tags = object.tags.where(category: people)
    output = tags.map { |tag| tag.name }
    output.join ", "
  end

  def activities
    activities = Category.where(name: "activities")
    tags = object.tags.where(category: activities)
    output = tags.map { |tag| tag.name }
    output.join ", "
  end

  def tags
    other = Category.where(name: "other")
    tags = object.tags.where(category: other)
    output = tags.map { |tag| tag.name }
    output.join ", "
  end


end
