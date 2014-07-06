class PhotoTag < ActiveRecord::Base
  belongs_to :photo
  belongs_to :tag

  validates :tag, presence: true
  validates :photo, presence: true
end
