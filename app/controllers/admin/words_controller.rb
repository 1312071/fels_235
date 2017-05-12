class Admin::WordsController < ApplicationController
  before_action :logged_in_user, :verify_admin
  before_action :load_word, only: :show

  def show
    @answers = @word.answers
  end
end
