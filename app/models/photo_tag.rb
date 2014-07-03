class PhotoTag < ActiveRecord::Base
  belongs_to :photo
  belongs_to :tag

  validates :tag_id, presence: true
  validates :photo_id, presence: true
end
