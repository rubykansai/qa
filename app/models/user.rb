class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  has_many :subjects

  validates :email, uniqueness: true, email: true

  def self.authenticate(email, password)
    user = where(email: email).first
    return if user.nil?
    user if user.valid_password?(password)
  end
end
