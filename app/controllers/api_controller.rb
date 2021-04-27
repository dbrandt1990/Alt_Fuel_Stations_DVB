require 'httparty'

module ApiController 
    include HTTParty

    def self.get_stations_in_zip(user)
        user_zip = user.zip
        #apikey not hidden
        url = "https://developer.nrel.gov/api/alt-fuel-stations/v1.json?zip=#{user_zip}&api_key=#{ENV[API_KEY]}"
        doc = HTTParty.get(url)
        data = doc.parsed_response
        #return stations 
        data["fuel_stations"]
    end

    def self.get_stations_with_fuel_types(user)
        users_fuel_types = {
          ELEC: user.ELEC,
          BD: user.BD,
          CNG: user.CNG,
          E85: user.E85,
          HY: user.HY,
          LNG: user.LNG,
          LPG: user.LPG
        }


        fuel_type_url = []
        users_fuel_types.each do |type, user_setting|
            if user_setting
                fuel_type_url << type.to_s
            end
        end

        fuel_type_url = fuel_type_url.join(',')
       
        #apikey not hidden
        url = "https://developer.nrel.gov/api/alt-fuel-stations/v1.json?fuel_type=#{fuel_type_url}&zip=#{user.zip}&api_key=#{ENV[API_KEY]}"
        doc = HTTParty.get(url)
        data = doc.parsed_response
        #return stations 
        data["fuel_stations"]
    end


    #take method as an argument 
    def self.create_station_objects(user, method)
        method.each do |station|

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

            outlets = station["ev_connector_types"]
             
            station = user.stations.build(name: name, address: address, city: city, state: state, zip: zip, status: status, access: access)
            #set outlets for and fuel types for station
            outlets.each do |outlet|
                station.update(outlet.to_sym => true)
            end
            
            station.save
        end
    end

end