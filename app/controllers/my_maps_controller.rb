class MyMapsController < ApplicationController
  respond_to :html, :json
  include ApplicationHelper

  before_filter :authenticate,  except: :show
  before_filter :public_map_check,  only: :show

  def show
    @my_map = compile_my_map(params[:id])
    respond_with(@my_map)
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

    @my_map.attributes = my_map_params
    if !@my_map.save
      flash[:notice] = "Failed to save"
    end
    redirect_to edit_my_map_path(params[:id])
  end

  private

  def my_map_params
    params.required(:my_map).permit( :id, :name, :description, :is_public )
  end
end
