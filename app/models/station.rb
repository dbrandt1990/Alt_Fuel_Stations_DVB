class Station < ApplicationRecord
    has_secure_password
    has_many :users_stations
    has_many :users, through: :users_stations
    has_many :notes
end
