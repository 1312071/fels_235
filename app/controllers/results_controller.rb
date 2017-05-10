class ResultsController < ApplicationController
  before_action :logged_in_user, only: [:index, :update]
  before_action :correct_user_result, only: [:index, :edit, :update]

  def index
  end

  def edit
  end

  def update
    @result = Result.find_by id: params[:id]
    @count_answer = params[:answer].length
    while @count_answer > count_true_answer(@result) do
      Result.create answer_id: params[:answer][@count_answer - 1],
        word_id: @result.word_id, lesson_id: @result.lesson_id
      @count_answer -= 1
    end
    while @count_answer > 0 do
      @result.update_attributes answer_id: params[:answer][@count_answer - 1]
      @result = Result.where("id > #{@result.id}") unless @count_answer == 1
      @count_answer -= 1
    end
    if current_result_stt(@result) < 10
      result_next @result
      @count_answer = count_true_answer @result
      @view = "/results/result_single"
      @view = "/results/result_multiple" if @count_answer > 1
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
        @point += 1 if check_answer @result
        result_next @result
      end
      @lesson.update_attributes point: @point, is_finish: "True"
    end
  end

  private

  def correct_user_result
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
