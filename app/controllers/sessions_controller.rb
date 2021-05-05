class SessionsController < ApplicationController
    skip_before_action :verify_authenticity_token, :only => :omniauth
    extend ApiController

    def new
        if user_signed_in?
            redirect_to user_path(current_user.id)
        else
            render 'sessions/new'
        end
    end

    def omniauth
        auth_hash = request.env['omniauth.auth']
        user = User.find_or_create_by(email: auth_hash['info']['email'])
        if user.id.nil?
            user.name = auth_hash['info']['name']         
            user.password = SecureRandom.hex(10)
            user.save
        end
        session[:user_id] = user.id
        redirect_to user_path(user)
    end

    def create
        @user = User.find_by(email: params[:user][:email]) 
        if @user.nil?
          redirect_to new_user_path, alert: 'No user found, please sign up'
        else
          return head(:forbidden) unless @user.authenticate(params[:user][:password])   
          session[:user_id] = @user.id   
          redirect_to user_path(@user)
        end
    end

    def destroy
        session.clear
        redirect_to root_path
    end
    
end