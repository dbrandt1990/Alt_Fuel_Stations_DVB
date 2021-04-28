require 'httparty'

module ApiController 
    include HTTParty

    def self.check_if_stations_exist_in_db(get_stations)
        stations_to_add = []
        get_stations.each do |s|
            if Station.find_by(api_id: s.api_id).nil?
                stations_to_add << s
            end
        end 
        #!if they exist don't add them, but associate them with the user trying to access them
        byebug
        stations_to_add
    end

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
            api_id = station["id"]
            phone = station["station_phone"]

            outlets = station["ev_connector_types"]
            #build station through user only if they do not already have it.
            if user.stations.find_by(api_id: api_id).nil? && Station.find_by(api_id: api_id).nil?

                #byebug #!getting multiple of the same id after update settings
                user_station = user.stations.build
                    (name: name,
                    address: address, 
                    city: city,
                    state: state,
                    zip: zip, 
                    status: status, 
                    access: access, 
                    api_id: api_id, 
                    phone: phone
                    #fuel_types
                    ELEC: user.ELEC,
                    BD: user.BD,
                    CNG: user.CNG
                    LPG: user.LPG
                    LNG: user.LNG
                    HY: user.HY
                    E85:user.E85
                )
                #set outlets for station
                outlets.each do |outlet|
                    user_station.update(outlet.to_sym => true)
                end

                user_station.save
            elsif Station.find_by(api_id: api_id)
                user.stations << Station.find_by(api_id: api_id)
            end
        end
    end

end