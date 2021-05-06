require_relative './api_controller.rb'

class StationsController < ApplicationController

    def index
        @stations = current_user.stations
        render '/users/users_stations'
    end

    def scope
        scope_method = params[:scope]
        if scope_method == "flagged"
            @stations =  Station.where(zip: current_user.zip).flagged
        else 
            @stations =  Station.where(zip: current_user.zip).residential
        end
        @message = "Displaying #{params[:scope].capitalize} Stations in #{current_user.zip}"
        
        render '/users/show'
    end

    def show 
        @station = Station.find_by(id:params[:id])
        render '/stations/show'
    end

    def new
        @station = Station.new
    end

    def create
        current_user.stations.build(
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
        ).save
        redirect_to user_path(current_user)
    end

    def add_user
        #add check if user already has station
        station = Station.find(params[:id])
        if current_user.stations.find_by(api_id: station.api_id).nil?
            station.users << current_user
            redirect_to "/users/#{current_user.id}/stations"
        else
            flash[:alert] = "You've already added that station."
            redirect_to user_path(current_user)
        end
    end

    def delete_user
        current_user.stations.delete(Station.find_by(id: params[:id]))
        redirect_to "/users/#{current_user.id}/stations"
    end

    def search
        @stations = ApiController.create_station_objects(params[:zip], ApiController.get_stations_from_zip(params[:zip]))
        render '/stations/search'
    end

    def check_for_updates
        #use ['id'] for new_stations, and api_id for stations in the DB
        current_stations = Station.where(zip: current_user.zip)
        new_stations = ApiController.get_stations_from_zip(current_user.zip)
    
        if current_stations.count != new_stations.count
            #station in our DB no longer in API
            if new_stations.count < current_stations.count
                current_stations.each do |station|
                    
                    if !new_stations.select{|s| s['id'] == station.api_id}.any?
                        @message = "#{station.name}, has been removed."
                        station.destroy
                        render "/stations/check_for_updates"
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