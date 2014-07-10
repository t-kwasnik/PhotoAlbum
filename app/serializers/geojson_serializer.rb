class GeojsonSerializer < ActiveModel::Serializer
  attributes :type, :geometry, :properties

  def type
    if has_geom(object)
      "Feature"
    else
      "Unmapped"
    end
  end

  def geometry
    if has_geom(object)
      { type: "Point", coordinates: [ object.geom.x, object.geom.y, object.geom.z]}
    else
      ""
    end
  end
end
