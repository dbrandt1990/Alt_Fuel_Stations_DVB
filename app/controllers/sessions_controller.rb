require_relative './api_controller.rb'

class SessionsController < ApplicationController
    skip_before_action :require_login, only: [:new, :create, :omniauth]
    skip_before_action :verify_authenticity_token, :only => :omniauth

    def new
        if user_signed_in?
            redirect_to user_stations_path(current_user.id)
        else
            render 'sessions/new'
        end
    end

    def create
        #refactor 
        if request.env['omniauth.auth']
            @user = User.from_omniauth(request.env['omniauth.auth'])
            session[:user_id] = @user.id 
            redirect_to user_stations_path(@user)
        else
            @user = User.find_by(email: params[:user][:email]) 
            if @user.nil?
              redirect_to new_user_path, alert: 'No user found, please sign up'
            else
              return head(:forbidden) unless @user.authenticate(params[:user][:password])   
              session[:user_id] = @user.id   
              redirect_to user_stations_path(@user)
            end
        end
    end

    def destroy
        session.clear
        redirect_to root_path
    end
    
end