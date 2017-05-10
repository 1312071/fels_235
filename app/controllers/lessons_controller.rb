class LessonsController < ApplicationController
  before_action :logged_in_user, only: [:new, :show, :create]
  before_action :load_lesson, only: [:show, :check_user_for_lesson,
    :verify_lesson_finished]
  before_action :verify_lesson_finished, :check_user_for_lesson, only: :show
  before_action :check_lesson_limit, only: :create

  def new
  end

  def show
    @result = @lesson.current_result
  end

  def create
    Lesson.transaction do
      @lesson = current_user.lessons.build category_id: params[:lesson][:category_id]
      if @lesson.check_word_for_lesson && @lesson.save!
        redirect_to lesson_url @lesson
      else
        flash[:danger] = t "lessons.create.start_lesson_failed"
        redirect_to categories_url
      end
    end
  end

  private

  def check_user_for_lesson
    unless @lesson.user_id == current_user.id
      flash[:danger] = t "results.correct_user.not_privilege"
      redirect_to categories_url
    end
  end

  def load_lesson
    @lesson = Lesson.find_by id: params[:id]
    unless @lesson
      flash[:danger] = t "lessons.load_lesson.lesson_invalid"
      redirect_to categories_url
    end
  end

  def verify_lesson_finished
    if @lesson.is_finish?
      flash[:danger] = t "lessons.verify_lesson_finished.lesson_finished"
      redirect_to categories_url
    end
  end

  def check_lesson_limit
    if Lesson.where(category_id: params[:lesson][:category_id]).count ==
        Settings.lesson.limit_lesson
      flash[:danger] = t "lessons.check_lesson_limit.over_limit"
      redirect_to categories_url
    end
  end
end
