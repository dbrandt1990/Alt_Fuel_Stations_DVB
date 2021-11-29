require_relative './api_controller.rb'

class StationsController < ApplicationController

    def index
        @user = current_user
        @users_stations = UsersStation.where(user_id: current_user.id)
        @stations = @user.stations
        render '/users/users_stations'
    end

    def show 
        @user = current_user
        @station = Station.find_by(id:params[:id])
        @user_count = @station.users.count
        @station_notes = @station.notes
        render '/stations/show'
    end

    def residential
        @user = current_user
        @stations =  Station.where(zip: @user.zip).residential
        @message = "Displaying Residential Stations in #{@user.zip}"
        render '/users/show'
    end

    def new
        @station = Station.new
    end

    def create
        @station = current_user.stations.build(
            name: params[:station][:name],
            city: params[:station][:city],
            state: params[:station][:state],
            zip: params[:station][:zip],
            address: params[:station][:address],
            phone: params[:station][:phone],
            ELEC: true,
            status: "Pending Approval",
            access: "residential",
            flagged: true,
            updates: false
        )
        
        if @station.save
            redirect_to user_path(current_user)
        else    
           render :new
        end
    end

    def search
        @stations = ApiController.create_station_objects(params[:zip], ApiController.get_stations_from_zip(params[:zip]))
        render '/stations/search'
    end

    def check_for_updates
        #use ['id'] for new_stations, and api_id for stations in the DB
        user = current_user
        current_stations = Station.where(zip: user.zip)
        new_stations = ApiController.get_stations_from_zip(user.zip)
    
        if current_stations.count != new_stations.count
            #station in our DB no longer in API
            if new_stations.count < current_stations.count
                current_stations.each do |station|
                    
                    if !new_stations.select{|s| s['id'] == station.api_id}.any?

                        if station.access == "residential"

                            if station.flagged
                                @message = "#{station.name} Residential Station, is pending approval for public use."
                            else
                                @message = "#{station.name} Residential Staition, is availible for public use!"
                            end
                            render "/stations/check_for_updates"
                            
                        else
                            @message = "#{station.name}, has been removed."
                            station.destroy
                            render "/stations/check_for_updates"
                        end
                    end

                end
            #new station found in API
            elsif new_stations.count > current_stations.count
                new_stations.each do |station|
                    
                    if current_stations.find_by(api_id: station['id']).nil?
                        @message = "#{station['station_name']}, has been added in your area!."
                        ApiController.create_station(station)
                        render "/stations/check_for_updates"
                    end

                end
            end
        else
            @message = "No updates in your home zip."
            render "/stations/check_for_updates"
        end
    end

end