class Admin::UsersController < ApplicationController
  before_action :logged_in_user, :verify_admin
  before_action :load_user, except: [:index, :new, :create]

  def index
    @users = User.search(params[:search])
      .page(params[:page]).per Settings.user.param_pages_users
    respond_to do |format|
      format.js do
        render json: {
          html_user: render_to_string(partial: "/admin/users/user",
            locals: {users: @users}, layout: false
          ), status: 200
        }
      end
      format.html{render :index}
    end
  end

  def destroy
    unless is_learning @user.id
      @user.destroy ? flash[:success] =  t("users.message.user_deleted") :
        flash[:danger] = t("users.errors.not_deleted")
    else
      flash[:danger] = t "users.errors.cant_deleted"
    end
    redirect_to admin_users_url
  end
end
