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

          #add check for updated stations ie. new addresses, or repeated addresses
          redirect_to user_path(@user)
        end
    end

    def destroy
        session.clear
        redirect_to root_path
    end
    
end