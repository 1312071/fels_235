class WordsController < ApplicationController
  before_action :logged_in_user

  def index
    @words = Word.select(:id, :content, :category_id, :picture, :created_at)
      .includes(:category).order(:created_at)
      .page(params[:page]).per Settings.word.per_page
  end
end
