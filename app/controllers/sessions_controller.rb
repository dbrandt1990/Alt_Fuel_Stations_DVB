class SessionsController < ApplicationController
    extend ApiController

    def new
        if user_signed_in?
            redirect_to user_path(current_user.id)
        else
            redirect_to new_user_session_path
        end
    end

    def destroy
        session.clear
        redirect_to root_path
    end
    
end