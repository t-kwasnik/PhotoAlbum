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
