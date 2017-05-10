class LessonsController < ApplicationController
  before_action :logged_in_user, only: [:new, :show, :create]
  before_action :load_lesson, :verify_lesson_finished, :correct_user_lesson,
    only: [:show, :correct_user_lesson, :verify_lesson_finished]
  before_action :check_lesson_limit, only: :create

  def index
    @lessons = Lesson.includes(:category).where(user_id: current_user.id)
      .order(created_at: :desc)
  end

  def new
  end

  def show
    @result = current_result @lesson
  end

  def create
    Lesson.transaction do
      @lesson = current_user.lessons.build category_id: params[:lesson][:category_id]
      Word.transaction do
        @words = Word.where(category_id: params[:lesson][:category_id])
          .order("RANDOM()").limit Settings.lesson.word_per_lesson
        if @words.exists? && @lesson.save!
          @words.each do |word|
            @true_answer = count_true_answer_for_word word
            while @true_answer > 0 do
              @result = @lesson.results.build word_id: word.id
              @true_answer -= 1
              unless @result.save!
                raise ActiveRecord::Rollback
              end
            end
          end
        redirect_to lesson_path @lesson
        else
          flash[:danger] = t "lessons.create.start_lesson_failed"
          redirect_to categories_url
          raise ActiveRecord::Rollback
        end
      end
    end
  end

  private

  def correct_user_lesson
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
