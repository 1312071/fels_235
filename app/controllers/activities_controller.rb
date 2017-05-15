class ActivitiesController < ApplicationController
  before_action :logged_in_user, :load_user

  def index
    @activities = Activity.user_activity(@user.id).page(params[:page])
      .per Settings.activity.per_page
  end
end
