require 'httparty'

module ApiController
    include HTTParty

    def self.get_stations_from_zip(zip)
        zip_code = zip
        url = "https://developer.nrel.gov/api/alt-fuel-stations/v1.json?zip=#{zip_code}&api_key=#{ENV['API_KEY']}"
        doc = HTTParty.get(url)
        data = doc.parsed_response
        data["fuel_stations"]
    end

    def self.create_station(station)
        if !station.nil?
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

                station = Station.new(
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
                if !outlets.nil?
                    if !outlets.empty?
                        outlets.each do |outlet|
                            station.update(outlet.upcase.to_sym => true)
                        end
                    end
                end

                if fuel_type_code.is_a?(Array)
                    fuel_type_code.each do |f|
                        station.update(f.upcase.to_sym => true)
                    end
                else
                    station.update(fuel_type_code.to_sym => true)
                end 

                station.save
        end
    end

    #use appropriate api get method
    def self.create_station_objects(zip, method)
        #array to return stations found.
        stations = []
        #ONLy make api call if user and DB don't have station already
        if Station.find_by(zip: zip).nil?

            method.each do |station|
                ApiController.create_station(station)
            end 
            stations = Station.where(zip: zip)
        #add station from DB if user doesn't have
        else 
            stations = Station.where(zip: zip)
        end
        stations
    end

        #!may not need this method, just get all in zip and then filter by check_settings in user controller
    # def self.get_stations_from_settings(user)
    #     users_fuel_types = {
    #       ELEC: user.ELEC,
    #       BD: user.BD,
    #       CNG: user.CNG,
    #       E85: user.E85,
    #       HY: user.HY,
    #       LNG: user.LNG,
    #       LPG: user.LPG
    #     }


    #     fuel_type_url = []
    #     users_fuel_types.each do |type, user_setting|
    #         if user_setting
    #             fuel_type_url << type.to_s
    #         end
    #     end

    #     fuel_type_url = fuel_type_url.join(',')
       
    #     url = "https://developer.nrel.gov/api/alt-fuel-stations/v1.json?fuel_type=#{fuel_type_url}&zip=#{user.zip}&api_key=#{ENV['API_KEY']}"
    #     doc = HTTParty.get(url)
    #     data = doc.parsed_response
    #     data["fuel_stations"]
    # end

end