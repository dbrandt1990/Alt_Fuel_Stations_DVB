class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user, :user_signed_in?

  def current_user
      User.find_by(id: session[:user_id])
  end

  def user_signed_in?
      current_user
  end

  private

  def require_login
    unless user_signed_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to new_user_path
    end
  end

end
