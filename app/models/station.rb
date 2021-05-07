class Station < ApplicationRecord
    has_many :users_station
    has_many :users, through: :users_station
    has_many :notes
    validates :name, presence: true
    validates :zip, presence: true, length: {is: 5}, numericality: true
    validates :address, presence: true
    validates :access, presence: true
    validates :phone, length: {is: 10},  numericality: true

    scope :residential, -> {where(access: 'residential')}
end
