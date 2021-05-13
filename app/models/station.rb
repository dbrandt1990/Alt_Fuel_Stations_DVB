class Station < ApplicationRecord
    has_many :users_station
    has_many :users, through: :users_station
    has_many :notes
    validates :name, presence: true
    validates :zip, presence: true, length: {is: 5}
    validates :address, presence: true
    validates :access, presence: true

    scope :residential, -> {where(access: 'residential')}
    #add more complex scope methods
end
