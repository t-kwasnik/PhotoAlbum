class MyMapsController < ApplicationController
  respond_to :html, :json
  include ApplicationHelper
  before_filter :authenticate

  def show
    my_map = MyMap.where(id: params[:id], user_id: current_user.id).first
    @my_map_hash = JSON.parse(my_map.to_json)
    @my_map_hash["photos"] = my_map.photos

    respond_with(@my_map_hash)
  end

  def create
    new_my_map = MyMap.new(my_map_params)
    new_my_map.user_id = current_user[:id]
    if new_my_map.save
      redirect_to my_map_path(new_my_map)
    else
      flash[:notice] = "Failed to create map - name can't be blank"
      redirect_to photos_path
    end
  end

  def edit

  end

  def update

  end

  private

  def my_map_params
    params.required(:my_map).permit( :id, :name, :description )
  end
end
