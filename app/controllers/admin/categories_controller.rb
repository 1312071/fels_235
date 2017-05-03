class Admin::CategoriesController < ApplicationController
  before_action :logged_in_user, :verify_admin
  before_action :load_category, only: [:edit, :update, :destroy]
  before_action :load_categories, only: [:index, :create]

  def index
    @category = Category.new
  end

  def new
    @category = Category.new
  end

  def edit
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

  def update
    if @category.update_attributes category_params
      flash[:success] = t ".update_success"
      redirect_to admin_categories_url
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t ".delete_cate"
    else
      flash[:danger] = t ".delete_cate_failed"
    end
    redirect_to admin_categories_url
  end

  private

  def category_params
    params.require(:category).permit :name, :description, :picture
  end

  def load_category
    @category = Category.find_by id: params[:id]
    unless @category
      flash[:danger] = t ".invalid_category"
      redirect_to admin_categories_url
    end
  end

  def load_categories
    @categories = Category.select(:id, :name, :description, :picture)
    .page(params[:page]).per Settings.category.cate_per_page
  end
end
