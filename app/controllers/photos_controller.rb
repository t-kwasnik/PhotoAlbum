class PhotosController < ApplicationController
  respond_to :html, :json
  include ApplicationHelper

  before_filter :authenticate

  def index
    @new_photo = Photo.new

    @photo_collection = []
    Photo.where(user_id: current_user.id).each do |photo|
      @photo_collection << geoJSON(photo.geom, { photo_id: photo.id, image: photo.image_url(:med), placename: photo.placename })
    end

    respond_with(@photo_collection)
  end

  def create
    photo_params[:image].each do |p|
      current = Photo.new(image: p )
      current.user_id = current_user.id

      if current.image.filename
        gps = EXIFR::JPEG.new(p.tempfile).gps

        if !gps.nil?
          #get lat/long
          current.geom = "POINT(#{gps.longitude} #{gps.latitude} #{gps.altitude})"
          current.direction = gps.image_direction

          #geocode lat/long
          url = URI.parse("http://api.tiles.mapbox.com/v3/examples.map-zr0njcqy/geocode/#{gps.longitude},#{gps.latitude}.json")
          req = Net::HTTP::Get.new(url.to_s)
          res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }

          JSON.parse(res.body)["results"].each do |results|
            results.each do |result|
              # if result["type"] == "city"
              #   current.city = result["name"]
              # elsif result["type"] == "province"
              #   current.state = result["name"]
              # elsif result["type"] == "country"
              #   current.country = result["name"]
              # end
            end
          end
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
