class PhotosController < ApplicationController
  respond_to :html, :json
  include ApplicationHelper

  before_filter :authenticate

  def index
    @my_maps = MyMap.where( user_id: current_user )
    @new_my_map = MyMap.new
    @photos = Photo.where( user_id: current_user )

    respond_with @photos, each_serializer: GeojsonSerializer
  end

  def show
    @photo = Photo.find( params[:id] )
    respond_with @photo
  end

  def create
    @photo = Photo.new( photo_params )
    @photo.user = current_user

    if @photo.image.filename
      gps = EXIFR::JPEG.new( @photo.image.file.file ).gps

      if !gps.nil?
        #get lat/long
        @photo.geom = "POINT(#{gps.longitude} #{gps.latitude} #{gps.altitude})"
        @photo.direction = gps.image_direction

        #geocode lat/long
        url = URI.parse("http://api.tiles.mapbox.com/v3/examples.map-zr0njcqy/geocode/#{gps.longitude},#{gps.latitude}.json")
        req = Net::HTTP::Get.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }

        JSON.parse(res.body)["results"].each do |results|
          results.each do |result|
            # if result["type"] == "city"
            #   @photo.city = result["name"]
            # elsif result["type"] == "province"
            #   @photo.state = result["name"]
            # elsif result["type"] == "country"
            #   @photo.country = result["name"]
            # end
          end
        end
      end
    end
    if !@photo.save
      flash.now[:alert] = "Failed to save #{@photo.image.filename}"
    else
      flash.now[:alert] = "Added #{@photo.image.filename}"
    end
    respond_to do |format|
      format.json { render json: @photo, serializer: GeojsonSerializer }
    end
  end

  private

  def photo_params
    params.required(:photo).permit( :image )
  end

  def default_serializer_options
    { root: false }
  end

end
