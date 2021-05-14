class UsersStationsController < ApplicationController

    def update 
        UsersStation.find(params[:id]).update(date_visited: params[:date_visited])
        redirect_to user_stations_path(current_user)
    end

    def create
        user = current_user
        u_id = params[:user_id]
        s_id = params[:id]
        if UsersStation.find_by(user_id: u_id, station_id: s_id).nil?
            UsersStation.create(user_id: u_id, station_id: s_id) 
            redirect_to user_stations_path(u_id)
        else
            flash[:alert] = "You've already added that station."
            redirect_to user_path(user)
        end
    end

    def destroy
        user = current_user
        u_id = params[:user_id]
        s_id = params[:id]
        station = UsersStation.find_by(user_id: u_id, station_id: s_id)
        station.destroy
        redirect_to user_stations_path(user.id)
    end
end