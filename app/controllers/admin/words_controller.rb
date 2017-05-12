class Admin::WordsController < ApplicationController
  before_action :logged_in_user, :verify_admin
  before_action :load_all_category, except: :destroy
  before_action :load_word, except: :index
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

  def edit
  end

  def update
    if @word.update_attributes word_params
      flash[:success] = t "admin.words.message.update_success"
      redirect_to admin_words_url
    else
      flash.now[:notice] = t "admin.words.error.update_failed"
      render :edit
    end
  end

  def destroy
    if @word.is_word_learned?
      if @word.destroy
        flash[:success] = t "admin.words.message.delete_success"
        redirect_to :back
      else
        flash[:danger] = t "admin.words.error.delete_failed"
      end
    else
      flash.now[:notice] = t "admin.words.error.delete_learned_word"
    end
  end


  private

  def word_params
    params.require(:word).permit :category_id, :content,
      answers_attributes: [:id, :content, :is_correct, :_destroy]
  end
end
