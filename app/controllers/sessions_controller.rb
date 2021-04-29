class SessionsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: :create
    extend ApiController

    def new
        if loggedin?
            redirect_to user_path(current_user.id)
        else
            render :login
        end
    end

    def create
        if auth_hash = request.env['omniauth.auth']['email']
              user = User.find_or_create_by_omniauth(auth_hash)
              session[:user_id] = user.id
              redirect_to user_path(@user)
        else
            @user = User.find_by(email: params[:email])
    
            if @user.nil?
              redirect_to new_user_path, alert: 'No user found, please sign up'
            else
              return head(:forbidden) unless @user.authenticate(params[:password])

              session[:user_id] = @user.id

              redirect_to user_path(@user)
            end
        end
    end

    def destroy
        session.clear
        redirect_to root_path
    end
    
end