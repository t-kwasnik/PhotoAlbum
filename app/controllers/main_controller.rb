class MainController < ApplicationController

  def root

    if current_user
      redirect_to photos_path
    else
      redirect_to main_index_path
    end
  end

  def index
    @photo_collection = Photo.all.where(is_public: true)
  end
end
