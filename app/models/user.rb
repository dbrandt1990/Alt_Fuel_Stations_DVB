class User < ApplicationRecord
    has_secure_password
    has_many :users_station
    has_many :stations, through: :users_station
    has_many :notes

    # def self.from_omniauth(auth)
    #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    #     user.email = auth.info.email
    #     user.password = Devise.friendly_token[0, 20]
    #     user.name = auth.info.name 
    #     # skip the confirmation emails.
    #     user.skip_confirmation!
    #   end
    # end

end
