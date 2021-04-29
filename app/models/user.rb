class User < ApplicationRecord
    has_secure_password
    validates :email, uniqueness:{message: "already exists."}
    has_many :users_station
    has_many :stations, through: :users_station
    has_many :notes

    def updates?
        if self.updates 
            "NEW station added to your zip!"
        end
    end
end
