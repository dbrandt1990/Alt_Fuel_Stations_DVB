require_relative './api_controller.rb'

class UsersController < ApplicationController
    skip_before_action :require_login, only: [:new, :create]

    def new
        if user_signed_in?
            redirect_to user_path(current_user)
        else
            @user = User.new
            render :new
        end
    end

    def create
        @user = User.new(user_params)

        if @user.save
            session[:user_id] = @user.id
            if !@user.zip.nil?
                ApiController.create_station_objects(@user.zip, ApiController.get_stations_from_zip(@user.zip))
            end
            redirect_to user_path(@user)
        else
            render :new
        end
    end

    def show
        @user = current_user
        if !@user.zip.nil?
            stations = Station.where(zip: @user.zip)
            if stations.empty?
                stations = ApiController.create_station_objects(@user.zip, ApiController.get_stations_from_zip(@user.zip))
            end
            @stations = []
        
                stations.each do |s|
                    if check_settings(s, @user)
                    @stations << s
                end
            end
            @stations
        else
            @stations = []
            flash.now[:alert] = "Go to settings to set your home zip."
        end
    end

    def update
        user = current_user
        email = params[:user][:email]
        password = params[:user][:password]

        if email != ""
            user.update(email: email)
        end
        if password != ""
            user.update(password: password)
        end
        
        redirect_to edit_user_path(user), alert: "User updated"
    end
    
    def destroy
        User.find(current_user.id).destroy
        redirect_to new_user_path
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
        user = current_user
        user.update(settings_params)

        ApiController.create_station_objects(user.zip, ApiController.get_stations_from_zip(user.zip))

        redirect_to user_path(user.id)
    end

    private 

    def user_params
        params.require(:user).permit(:name, :zip, :email, :password)
    end

    def settings_params
        params.require(:user).permit(
            :name,
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