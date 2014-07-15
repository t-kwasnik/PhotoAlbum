class TagsController < ApplicationController
  respond_to :html, :json
  include ApplicationHelper

  def create
    category = Category.where( name: tag_params["category"] ).first
    tag = Tag.new( name: tag_params["name"], category: category  )
    if tag.save
      respond_to do |format|
        format.json { render json: tag }
      end
    end

  end

  private

  def tag_params
    params.required(:tag).permit( :name, :category )
  end

end
