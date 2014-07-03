class MyMapPhoto < ActiveRecord::Base
  belongs_to :my_map
  belongs_to :photo

  validates :my_map_id, presence: true
  validates :photo_id, presence: true
  validates :order, presence: true

end
