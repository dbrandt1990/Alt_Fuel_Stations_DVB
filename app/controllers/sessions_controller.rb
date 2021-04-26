class SessionsController < ApplicationController
    extend ApiController

    def new
        if loggedin?
            redirect_to user_path(current_user.id)
        else
            render :login
        end
    end

    def create
        @user = User.find_by(email: params[:email])
       
        if @user.nil?
          redirect_to new_user_path, alert: 'No user found, please sign up'
        else
          return head(:forbidden) unless @user.authenticate(params[:password])

          session[:user_id] = @user.id

          #makes api call to generate all stations for user's given zip
          ApiController.create_station_objects(@user)

          redirect_to user_path(@user)
        end
    end

    def destroy
        session.clear
        redirect_to root_path
    end
    
end