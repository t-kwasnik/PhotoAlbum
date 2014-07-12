class MyMapPhotosController < ApplicationController
  respond_to :html, :json
  include ApplicationHelper
  before_filter :authenticate

  def create
    @my_map_photo = MyMapPhoto.new(my_map_photo_params)
    @my_map_photo.my_map_id = params[:my_map_id]

    if @my_map_photo.save
      respond_to do |format|
        format.json { render json: @my_map_photo }
      end
    end
  end

  def update
    @my_map_photo = MyMapPhoto.find(params[:id])

    if @my_map_photo.my_map.user != current_user then redirect_to main_index_path end

    @my_map_photo.attributes = my_map_photo_params

    if !@my_map_photo.save
      flash[:notice] = "Failed to save"
    end
    redirect_to edit_my_map_path(params[:my_map_id])
  end

  private

  def my_map_photo_params
    params.required(:my_map_photo).permit( :my_map, :name, :description, :photo_id, :order )
  end
end
