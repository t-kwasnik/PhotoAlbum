class MyMapsController < ApplicationController
  respond_to :html, :json
  include ApplicationHelper

  before_filter :authenticate, except: :show

  def show
    @my_map = compile_my_map(params[:id])

    public_map = @my_map["is_public"]

    if ( current_user ? ( !public_map && ( current_user.id == @my_map["user_id"] ) ) : false ) || public_map
      respond_with(@my_map)
    else
      flash[:notice] = "You need to sign in first."
      redirect_to main_index_path
    end
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
    @my_map = MyMap.find(params[:id])
    @my_map_photos = @my_map.my_map_photos.order(:order)
  end

  def update
    @my_map = MyMap.find(params[:id])

    if @my_map.user != current_user then redirect_to main_index_path end

    @my_map.attributes = my_map_params

    if !@my_map.save then flash[:notice] = "Failed to save" end

    redirect_to edit_my_map_path(params[:id])
  end

  private

  def my_map_params
    params.required(:my_map).permit( :id, :name, :description, :is_public )
  end
end
