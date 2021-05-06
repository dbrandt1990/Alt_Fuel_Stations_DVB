class User < ApplicationRecord
    has_secure_password
    has_many :users_station
    has_many :stations, through: :users_station
    has_many :notes

    def self.from_omniauth(auth_hash)
        user = User.find_or_create_by(email: auth_hash['info']['email'])
        if user.id.nil?
            user.name = auth_hash['info']['name']         
            user.password = SecureRandom.hex(10)
            user.save
            user
        else
            user
        end
    end
end
