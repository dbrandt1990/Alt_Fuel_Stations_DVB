require 'httparty'

module ApiController 
    include HTTParty

    def self.get_stations_in_zip(user)
        user_zip = user.zip
        #apikey not hidden
        url = "https://developer.nrel.gov/api/alt-fuel-stations/v1.json?fuel_type=ELEC&zip=#{user_zip}&api_key=POnKXCaEBoeNLnFxbTF6Fc2KhMnBPKslr7oytOYk"
        doc = HTTParty.get(url)
        data = doc.parsed_response
        #return stations 
        data["fuel_stations"]
    end

    def self.create_station_objects(user)
        get_stations_in_zip(user).each do |station|

            name = station["station_name"]

            if station["status_code"] == "E"
                status = "Availible"
            elsif station["status_code"] == "P"
                status = "Planned for Construction"
            else
                status = "Temporarily Unavailible"
            end
            
            address = station["street_address"] 
            city = station["city"]
            state = station["state"]
            zip = station["zip"]
            access = station["access_code"]

            #get array of outlets, set station attr for given outlet to true if exists
            # outlets = station["ev_connector_types"]
             
            user.stations.build(name: name, address: address, city: city, state: state, status: status, access: access).save
        end
    end
end