class UsersStationsController < ApplicationController
    def update 
        UsersStation.find(params[:id]).update(date_visited: params[:date_visited])
        redirect_to user_stations_path(current_user)
    end
end