class User < ApplicationRecord
    has_secure_password
    has_many :users_station
    has_many :stations, through: :users_station
    has_many :notes
end
