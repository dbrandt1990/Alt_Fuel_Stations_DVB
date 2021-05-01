class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    has_secure_password
    validates :email, uniqueness:{message: "already exists."}
    has_many :users_station
    has_many :stations, through: :users_station
    has_many :notes
#!Oauth 
    # def self.find_or_create_by_omniauth(auth_hash)
    #     self.where(email: auth_hash['info']['email']).first_or_create do |user|
    #         user.password = SecureRandom.hex
    #     end
    # end
end
