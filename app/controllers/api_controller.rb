class ApiController < ApplicationController

    def get_stations_in_zip
        #url format
        user_zip = current_user.zip
        stations = https://developer.nrel.gov/api/alt-fuel-stations/v1.json?fuel_type=ELEC&zip=user_zip&api_key=ENV[API_KEY]
        
    end

end