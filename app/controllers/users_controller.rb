class UsersController < ApplicationController

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)

        if @user.save
            session[:user_id] = @user.id

        #makes api call to generate all stations for user's given zip
            ApiController.create_station_objects(@user, ApiController.get_stations_in_zip(@user))

            redirect_to user_path(@user)
        else
            render new_user_path
        end
    end

    def show
        @user = current_user
        @stations = @user.stations

    end

    def settings
        @user = current_user
        render '/users/settings'
    end

    def update_settings
        current_user.update(settings_params)
        ApiController.create_station_objects(current_user, ApiController.get_stations_with_fuel_types(current_user))
        redirect_to user_path(current_user.id)
    end

    private 

    def user_params
        params.require(:user).permit(:name, :zip, :email, :password)
    end

    def settings_params
        params.require(:user).permit(
            :name,
            :email,
            :zip,
            :BD,
            :ELEC,
            :CNG,
            :E85,
            :HY,
            :LNG,
            :LPG
        )

    end
end