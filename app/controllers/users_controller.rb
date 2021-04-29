class UsersController < ApplicationController
    extend ApiController

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)

        if @user.save
            session[:user_id] = @user.id

            ApiController.create_station_objects(@user, ApiController.get_stations_from_zip(@user.zip))

            redirect_to user_path(@user)
        else
            render new_user_path
        end
    end

    def show
        @user = current_user
        stations = Station.where(zip: @user.zip)
        @stations = []
        
        stations.each do |s|
            if check_settings(s,@user)
                @stations << s
            end
        end

        @stations
    end
#show all users stations
    def users_stations
        @user = current_user
        @stations = @user.stations
        render '/users/users_stations'
    end

    def settings
        @user = current_user
        render '/users/settings'
    end

    def check_settings(station, user)
       if (station.zip == user.zip &&
           station.ELEC == user.ELEC && 
           station.BD == user.BD && 
           station.CNG == user.CNG && 
           station.LPG == user.LPG && 
           station.LNG == user.LNG && 
           station.HY == user.HY && 
           station.E85 == user.E85)

        true
       else 
        false
       end
    end

    def update_settings
        current_user.update(settings_params)

        ApiController.create_station_objects(current_user, ApiController.get_stations_from_zip(current_user.zip))

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