class MainController < ApplicationController
  respond_to :html, :json
  def root
    if current_user
      redirect_to photos_path
    else
      redirect_to main_index_path
    end
  end

  def index
    @photo_collection = Photo.all.where(is_public: true)
    respond_with @photo_collection, each_serializer: GeojsonSerializer
  end
end
