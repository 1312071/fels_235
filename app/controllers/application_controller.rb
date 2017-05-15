class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  include UsersHelper
  include ResultsHelper

  helper_method :find_answer
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "users.errors.please_log_in"
      redirect_to login_url
    end
  end

  def correct_user
    redirect_to root_url unless @user.current_user? current_user
  end

  def load_user
    unless @user = User.find_by(id: params[:id])
      flash[:danger] = t "users.errors.err_find_user"
      redirect_to request.referrer || root_url
    end
  end

  def is_learning user_id
    Lesson.exists? user_id: user_id
  end

  def load_all_category
    unless @categories = Category.select(:name, :id).order("LOWER(name)")
      render_404
    end
  end

  def load_word
    unless @word = Word.includes(:answers).find_by(id: params[:id])
      render_404
    end
  end


  protected

  def render_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  def verify_admin
    unless current_user.is_admin?
      flash[:danger] = t "admin.categories.verify_admin.admin_required"
      redirect_to root_url
    end
  end
end
