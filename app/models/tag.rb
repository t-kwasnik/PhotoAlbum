class Tag < ActiveRecord::Base
  has_many :photo_tags
  has_many :photos, through: :photo_tags
  belongs_to :category

  validates :name, presence: true
  validates :category_id, presence: true
end
