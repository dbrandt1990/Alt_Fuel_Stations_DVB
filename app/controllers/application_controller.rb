class ApplicationController < ActionController::Base
    #? Maybe add a dictionary for outlet and fuel types
    helper_method :current_user, :loggedin?, :admin?

    def current_user
        User.find_by(id:session[:user_id])
    end

    def loggedin?
        current_user
    end

    def admin?
        current_user.admin 
    end
end
