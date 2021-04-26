class ApiController < ApplicationController
    def user_fuel_types
        if current_user.ELEC?
            #get outlet types
        else
            #ignore outlets and get fuels
        end
    end

    def get_stations_in_zip
        #url format
        user_zip = current_user.zip
        https://developer.nrel.gov/api/alt-fuel-stations/v1.json?fuel_type=ELEC&zip=user_zip&api_key=ENV[API_KEY]
    end
end