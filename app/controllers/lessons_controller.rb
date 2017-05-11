class LessonsController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :show, :create]
  before_action :load_lesson, :check_user_for_lesson, :verify_lesson_finished,
    only: :show

  def index
    @lessons = current_user.lessons.includes(:category).where(is_finish: true)
      .search(params[:Category]).order(created_at: :desc).page(params[:page])
      .per Settings.lesson.lesson_per_page
  end

  def new
  end

  def show
    @result = @lesson.current_result
  end

  def create
    Lesson.transaction do
      @lesson = current_user.lessons.build category_id: params[:lesson][:category_id]
      if @lesson.check_word_for_lesson
        if @lesson.save!
        @lesson.activities.create user_id: @lesson.user_id,
          action_type: Activity.actions[:start_lesson]
        redirect_to lesson_url @lesson
        else
          flash[:danger] = t "lessons.create.start_lesson_failed"
          redirect_to categories_url
        end
      else
        flash[:danger] = t "lessons.create.not_enough_word"
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
