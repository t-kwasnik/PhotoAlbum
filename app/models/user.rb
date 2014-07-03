class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :photos, dependent: :destroy
  has_many :cities, through: :photos
  has_many :states, through: :photos
  has_many :countries, through: :photos
  has_many :my_maps, dependent: :destroy

  validates :username, uniqueness: true

end
