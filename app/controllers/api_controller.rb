require 'httparty'

module ApiController

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

    def self.create_station_objects(zip, method)
        #ONLY make api call if user and DB don't have station already
        if Station.find_by(zip: zip, access: 'private').nil? && Station.find_by(zip: zip, access: 'public').nil?
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
end