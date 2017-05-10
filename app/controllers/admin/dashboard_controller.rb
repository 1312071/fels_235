class Admin::DashboardController < ApplicationController
  before_action :logged_in_user, :verify_admin

  def index
  end
end
