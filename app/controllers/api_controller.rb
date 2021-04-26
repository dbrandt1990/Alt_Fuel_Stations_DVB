require 'httparty'

class ApiController < ApplicationController
    include HTTParty

    def get_stations_in_zip
        user_zip = current_user.zip
        url = https://developer.nrel.gov/api/alt-fuel-stations/v1.json?fuel_type=ELEC&zip=user_zip&api_key=ENV[API_KEY]
        doc = HTTParty.get(url)
        data = do.parsed_response
        #return stations 
        data["fuel_stations"]
    end

    def create_station_objects
        get_stations_in_zip.each do |station|

            name = station["station_name"]

            if station[status_code] == "E"
                status = "Availible"
            elsif station[status_code] == "P"
                status = "Planned for Construction"
            else
                status = "Temporarily Unavailible"
            end
            

            #add state and city to address
            state = station["state"]
            city = station["city"]

            address = "#{station['street_address']}, #{city}, #{state} "
            zip = station["zip"]
            access = station["access_code"]

            #get array of outlets, set station attr for given outlet to true if exists
            outlets = station[]
             
            current_user.stations.build(name: name, address: address, status: status, access: access)
        end
    end
end