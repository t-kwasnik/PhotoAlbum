class MyMap < ActiveRecord::Base
  belongs_to :user
  has_many :my_map_photos
  has_many :photos, through: :my_map_photos

  validates :name, presence: true
  validates :user_id, presence: true
end
