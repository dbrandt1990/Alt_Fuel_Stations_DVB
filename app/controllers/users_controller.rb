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
            redirect_to users_sign_up_path
        end
    end

    def show
        if !current_user.zip.nil?
            stations = Station.where(zip: current_user.zip)
            if stations.empty?
                stations = ApiController.create_station_objects(current_user.zip, ApiController.get_stations_from_zip(current_user.zip))
            end
            @stations = []
        
                stations.each do |s|
                    if check_settings(s,current_user)
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
        email = params[:user][:email]
        password = params[:user][:password]

        if email != ""
            current_user.update(email: email)
        end
        if password != ""
            current_user.update(password: password)
        end
        redirect_to edit_user_path(current_user), alert: "User updated"
    end
    
    def destroy
        User.find(current_user.id).destroy
        redirect_to users_sign_up_path
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

        ApiController.create_station_objects(current_user.zip, ApiController.get_stations_from_zip(current_user.zip))

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