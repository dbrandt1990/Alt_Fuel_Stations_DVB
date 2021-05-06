class Station < ApplicationRecord
    has_many :users_station
    has_many :users, through: :users_station
    has_many :notes

    scope :residential, -> {where(access: 'residential')}
    scope :flagged, -> {where( flagged: true)}
end
