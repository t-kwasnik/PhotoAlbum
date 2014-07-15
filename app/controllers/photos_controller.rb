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
    respond_to do |format|
      format.json { render json: @photo }
    end
  end

  def update
    @photo = Photo.find( params[:id] )
    @photo.update_attributes( photo_params )
    if @photo.save
      respond_to do |format|
        format.json { render json: @photo }
      end
    end
  end

  def create
    @photo = Photo.from_file( photo_params[:image] )
    @photo.user = current_user

    if !@photo.save
      flash.now[:notice] = "Failed to save #{@photo.image.filename}"
    else
      flash.now[:notice] = "Added #{@photo.image.filename}"
    end
    respond_to do |format|
      format.json { render json: @photo, serializer: GeojsonSerializer }
    end
  end

  private

  def photo_params
    params.required(:photo).permit( :image, :name, :description, :placename )
  end

  def default_serializer_options
    { root: false }
  end

end
