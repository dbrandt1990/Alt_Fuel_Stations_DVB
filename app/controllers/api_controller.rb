require 'httparty'

module ApiController 
    include HTTParty

    def self.get_stations_in_zip(user)
        user_zip = user.zip
        url = "https://developer.nrel.gov/api/alt-fuel-stations/v1.json?zip=#{user_zip}&api_key=#{ENV['API_KEY']}"
        doc = HTTParty.get(url)
        data = doc.parsed_response
        data["fuel_stations"]
    end

    def self.get_stations_from_settings(user)
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
       
        url = "https://developer.nrel.gov/api/alt-fuel-stations/v1.json?fuel_type=#{fuel_type_url}&zip=#{user.zip}&api_key=#{ENV['API_KEY']}"
        doc = HTTParty.get(url)
        data = doc.parsed_response
        data["fuel_stations"]
    end


    #use appropriate api get method
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
            api_id = station["id"]
            phone = station["station_phone"]
            fuel_type_code = station["fuel_type_code"]
      

            outlets = station["ev_connector_types"]
            #build station through user only if they do not already have it.
            if user.stations.find_by(api_id: api_id).nil? && Station.find_by(api_id: api_id).nil?

                #byebug #!getting multiple of the same id after update settings
                user_station = user.stations.build(
                    name: name,
                    address: address, 
                    city: city,
                    state: state,
                    zip: zip, 
                    status: status, 
                    access: access, 
                    api_id: api_id, 
                    phone: phone,
                )
                #set outlets and fuel types for station
                if !outlets.empty?
                    outlets.each do |outlet|
                        user_station.update(outlet.to_sym => true)
                    end
                end

                if fuel_type_code.is_a?(Array)
                    fuel_type_code.each do |f|
                        user_station.update(f.to_sym => true)
                    end
                else
                    user_station.update(fuel_type_code.to_sym => true)
                end 

                user_station.save

            elsif Station.find_by(api_id: api_id)
                user.stations << Station.find_by(api_id: api_id)
            end
        end
    end

end