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
    # binding.pry
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
             if result["type"] == "city"
                if City.where( name: result["name"] ).empty?
                  @photo.city = City.create( name: result["name"] )
                else
                  @photo.city = City.where( name: result["name"] ).first
                end
             elsif result["type"] == "province"
              if State.where( name: result["name"] ).empty?
                  @photo.state = State.create( name: result["name"] )
                else
                  @photo.state = State.where( name: result["name"] ).first
                end
             elsif result["type"] == "country"
               if Country.where( name: result["name"] ).empty?
                  @photo.country = Country.create( name: result["name"] )
                else
                  @photo.country = Country.where( name: result["name"] ).first
                end
             end
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
