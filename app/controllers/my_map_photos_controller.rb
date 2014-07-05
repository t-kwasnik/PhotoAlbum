class MyMapPhotosController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate

  def update
    @my_map_photo = MyMapPhoto.find(params[:id])

    @my_map_photo.attributes = my_map_photo_params
    if !@my_map_photo.save
      flash[:notice] = "Failed to save"
    end
    redirect_to edit_my_map_path(params[:my_map_id])
  end

  private

  def my_map_photo_params
    params.required(:my_map_photo).permit( :id, :my_map_id, :name, :description )
  end
end
