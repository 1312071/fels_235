class ResultsController < ApplicationController
  before_action :logged_in_user, only: [:index, :update]
  before_action :correct_user_result, only: [:index, :edit, :update]
  before_action :load_result, only: [:edit, :update]

  def index
  end

  def edit
  end

  def update
    @result.update_attributes_answer params[:answer]
    if @result.current_result_index < Settings.lesson.word_per_lesson
      @result = Result.result_next @result.id, @result.word_id
      @count_answer = @result.count_true_answer
      @view = "/results/result_single"
      @view = "/results/result_multiple" if @count_answer > Settings.result.single_answer
      respond_to do |format|
        format.js do
          render json: {
            question: render_to_string(partial: @view,
              locals: {object: @result}, layout: false
            ), status: 200
          }
        end
        format.html{render :show}
      end
    else
      @result = Result.find_by lesson_id: @result.lesson_id
      @point = 0
      while @result do
        @point += 1 if @result.check_answer
        @result = Result.result_next @result.id, @result.word_id
      end
      @lesson.update_point @point
    end
  end

  private

  def correct_user_result
    @lesson = Lesson.find_by id: params[:lesson_id], user_id: current_user.id
    unless @lesson
      flash[:danger] = t "results.correct_user.not_privilege"
      redirect_to lessons_url
    end
  end

  def load_result
    unless @result = Result.find_by(id: params[:id])
      flash[:danger] = t "results.load_result.result_invalid"
      redirect_to lessons_url
    end
  end
end
