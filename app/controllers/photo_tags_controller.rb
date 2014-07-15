class PhotoTagsController < ApplicationController
  respond_to :html, :json
  include ApplicationHelper

  def create
    photo_tag = PhotoTag.new( photo_tag_params )
    if photo_tag.save
      respond_to do |format|
        format.json { render json: photo_tag }
      end
    end
  end

  def destroy
    photo_tag = PhotoTag.find( params[:id] )
    if photo_tag.destroy
      respond_to do |format|
        format.json { render json: photo_tag }
      end
    end
  end

  private

  def photo_tag_params
    params.required(:photo_tag).permit( :photo_id, :tag_id )
  end

end
