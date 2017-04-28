class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  include UsersHelper

  helper_method :find_answer
  def logged_in_user
    unless logged_in?
      flash[:danger] = t ".log_in"
      redirect_to login_url
    end
  end

  def correct_user
    redirect_to root_url unless @user.current_user? current_user
  end

  def load_user
    unless @user = User.find_by(id: params[:id])
      flash[:danger] = t ".err_find_user"
      redirect_to request.referrer || root_url
    end
  end
end
