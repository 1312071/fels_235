class Admin::WordsController < ApplicationController
  before_action :logged_in_user, :verify_admin
  before_action :load_all_category, only: :index
  before_action :load_word, only: :show

  def index
    params[:search_word] ||= ""
    @words = Word.select(:id, :content, :category_id).includes(:category)
      .filter_category(params[:category_id])
      .get_all(params[:search_word])
      .page(params[:page]).per Settings.word.per_page
  end

  def show
    @answers = @word.answers
  end
end
