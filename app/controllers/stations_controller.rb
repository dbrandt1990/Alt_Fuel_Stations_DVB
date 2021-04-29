require_relative './api_controller.rb'

class StationsController < ApplicationController
    def show 
        @station = Station.find_by(id:params[:id])
        render '/stations/show'
    end

    def add_user
        station = Station.find(params[:id])
        station.users << current_user
        redirect_to "/users/#{current_user.id}/stations"
    end
#!changed to try and remove from users stations instead of Stations
    def destroy
        station = current_user.stations.find_by(id: params[:id])
        station.destroy
        redirect_to "/users/#{current_user.id}/stations"
    end
end