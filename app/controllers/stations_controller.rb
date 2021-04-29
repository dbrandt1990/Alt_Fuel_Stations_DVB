require_relative './api_controller.rb'

class StationsController < ApplicationController
    def show 
        @station = Station.find_by(id:params[:id])
        render '/stations/show'
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

    def search_form
        @stations = []
        render '/stations/search'
    end

    def search
        @stations = Station.all
        stations_in_db = Station.where(zip: params[:zip])

        if stations_in_db.any?
            @stations = stations_in_db
            render '/stations/search'
        else
           @stations = ApiController.create_station_objects(params[:zip], ApiController.get_stations_from_zip(params[:zip]))
           render '/stations/search'
        end
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
                        @message = "#{station['name']}, has been added in your area!."
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