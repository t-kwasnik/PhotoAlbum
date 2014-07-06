class MyMapPhoto < ActiveRecord::Base
  belongs_to :my_map
  belongs_to :photo

  validates :my_map, presence: true
  validates :photo, presence: true
  validates :order, presence: true

end
