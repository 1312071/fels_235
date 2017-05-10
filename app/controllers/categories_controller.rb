class CategoriesController < ApplicationController
  def index
    @categories = Category.includes(:words).search(params[:search])
      .order(name: :asc).page(params[:page]).per Settings.category.cate_per_page
  end
end
