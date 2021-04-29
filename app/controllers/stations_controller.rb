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

    def check_for_updates
        current_stations = Station.where(zip: current_user.zip)
        new_stations = ApiController.get_stations_from_zip(current_user.zip)

        if current_stations.count != new_stations.count
            new_stations.each do |s|
                #use id for new_stations, and api_id for stations in the DB
                if current_stations.find_by(api_id: s.id).nil?
                    Station.create(s)
                    flash[:alert] = "There are Updates in your zip"
                end
            end
        end
        flash[:alert] = "No Updates"
        redirect_to user_path(current_user)
    end
end