class PhotosController < ApplicationController
  respond_to :html, :json
  include ApplicationHelper

  def index

    @photos =  Photo.all
    @new_photo = Photo.new

    @photo_collection = { type: "FeatureCollection", features: [] }
    @photos.each do |photo|
      @photo_collection[:features] << geoJSON(photo.geom, { description: "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <img src=\"#{photo.image_url(:med)}\" width=\"300px\" />" }) if !photo.geom.nil?
    end

    respond_with(@photo_collection)
  end

  def create
    photo_params[:image].each do |p|
      current = Photo.new(image: p )

      if current.image.filename
        gps = EXIFR::JPEG.new(p.tempfile).gps

        if !gps.nil?
          current.geom = "POINT(#{gps.longitude} #{gps.latitude} #{gps.altitude})"
          current.direction = gps.image_direction
        end


        current.save
      end
    end

    redirect_to photos_path
  end

  private

  def photo_params
    params.required(:photo).permit(image:[])
  end

end
