class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :image, :is_public, :placename, :original_date, :related_maps, :people_tags, :activities_tags, :other_tags

  def description
    description = object.description
    description = " " if object.description.nil?
    description
  end

  def people_tags
    object.all_tags[:people]
  end

  def activities_tags
    object.all_tags[:activities]
  end

  def other_tags
    object.all_tags[:other]
  end

  def original_date
    object.original_date.strftime('%B %e, %Y at %l:%M %p')
  end

end
