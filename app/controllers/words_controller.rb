class WordsController < ApplicationController
  before_action :load_all_category, :logged_in_user, only: [:index]

  def index
    params[:search_word] ||= ""
    params[:condition] ||= Settings.filter_words.get_all
    @words = Word.select(:id, :content, :category_id, :picture, :created_at)
      .includes(:category).order(:created_at).filter_category(params[:category_id])
      .send(params[:condition], current_user.id, params[:search_word])
      .page(params[:page]).per Settings.word.per_page
  end
end
