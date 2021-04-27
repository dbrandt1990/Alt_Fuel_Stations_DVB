require_relative './api_controller.rb'

class StationsController < ApplicationController
    def show 
        @station = Station.find_by(id:params[:id])
        render '/stations/show'
    end

    def update

    end

    def destroy
        station = Station.find_by(id: params[:id])
        station.destroy
        redirect_to user_path(current_user)
    end
end