class StaticPagesController < ApplicationController
  def help
  end

  def home
    @activity_items = current_user.feed.page(params[:page])
      .per Settings.feed.param_pages if logged_in?
  end
end
