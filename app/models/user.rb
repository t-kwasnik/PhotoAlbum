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

  validates :username, uniqueness: true, presence: true

  attr_accessor :valid_new_email, :valid_new_username

  def valid_new_email
    if User.where( email: self.email ).empty?
      if self.email
        if self.email[/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i] == self.email
        return true
        end
      end
    end

    return false
  end

  def valid_new_username
    if User.where( username: self.username ).empty?
      if self.username
        if self.username.length > 5 && self.username.length < 15
        return true
        end
      end
    end
    return false
  end

end
