class Station < ApplicationRecord
    has_many :users_station
    has_many :users, through: :users_station
    has_many :notes

    scope :public_only, -> { where(access: 'public') }
end
