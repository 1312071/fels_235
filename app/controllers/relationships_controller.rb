class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: :show

  def show
    @title = params[:query]
    @users = @user.send("#{params[:query]}").page(params[:page])
      .per Settings.user.per_page
    render "users/show_follow"
  end

  def create
    if @user = User.find_by(id: params[:followed_id])
      current_user.follow @user
      respond_to do |format|
        format.html{redirect_to user}
        format.js
      end
    else
      flash[:danger] = t "users.errors.create_follow"
    end
  end

  def destroy
    if @user = Relationship.find_by(id: params[:id]).followed
      current_user.unfollow @user
      respond_to do |format|
        format.html{redirect_to user}
        format.js
      end
    else
      flash[:danger] = t "users.errors.destroy_follow"
    end

  end
end
