class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :auth_token, uniqueness: true

  before_create :generate_authentication_token!

  def generate_authentication_token!
    begin
      token = Devise.friendly_token
    end while User.where(auth_token: token).exists?
    self.auth_token = token
  end
end
