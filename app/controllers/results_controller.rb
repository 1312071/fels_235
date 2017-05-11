class ResultsController < ApplicationController
  before_action :logged_in_user, only: [:index, :update]
  before_action :check_user_result_for_lesson, only: [:index, :edit, :update]

  def index
    @results = Result.where(lesson_id: params[:lesson_id])
      .group(:word_id).order id: :asc
  end

  def edit
    @result = Result.find_by id: params[:id]
  end

  def update
    @result = Result.find_by id: params[:id]
    @result.update_answer params[:answer]
    if @result.current_result_stt < Settings.lesson.word_per_lesson
      result_next @result
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
        result_next @result
      end
      @lesson.update_point @point
    end
  end

  private

  def check_user_result_for_lesson
    @lesson = Lesson.find_by id: params[:lesson_id], user_id: current_user.id
    if @lesson.nil?
      flash[:danger] = t "results.correct_user.not_privilege"
      redirect_to lessons_url
    end
  end

  def result_next result
    @result = Result.where("id > #{result.id} AND word_id <> #{result.word_id}")
      .first
  end
end
