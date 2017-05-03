class Admin::CategoriesController < ApplicationController
  before_action :logged_in_user, :verify_admin, only: [:index, :new, :create]

  def index
    @category = Category.new
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t ".new_cate_success"
      redirect_to admin_categories_url
    else
      render :index
    end
  end

  private

  def category_params
    params.require(:category).permit :name, :description, :picture
  end
end
