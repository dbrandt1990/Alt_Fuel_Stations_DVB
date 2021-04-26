class User < ApplicationRecord
    has_secure_password
    has_many :users_stations
    has_many :stations, through: :users_stations
    has_many :notes
end
