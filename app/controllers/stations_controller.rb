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
#!changed to try and remove from users stations instead of Stations but still deleteing station from db
    def destroy
        current_user.stations.delete(Station.find_by(id: params[:id]))
        redirect_to "/users/#{current_user.id}/stations"
    end
end