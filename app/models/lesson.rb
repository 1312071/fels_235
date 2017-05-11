class Lesson < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :results, dependent: :destroy
  has_many :words, through: :results

  after_save :create_result_for_lesson

  scope :search, ->cate_id {where "category_id = #{cate_id}" unless cate_id.nil? || cate_id.empty?}

  def current_result
    self.results.where("answer_id IS NULL").first
  end

  def update_point point
    self.update_attributes point: point, is_finish: "True"
  end

  def check_word_for_lesson
    @words = Word.where(category_id: self.category_id)
      .limit Settings.lesson.word_per_lesson
    if @words.size == Settings.lesson.word_per_lesson
      true
    else
      false
    end
  end

  private

  def create_result_for_lesson
    if self.created_at == self.updated_at
      Result.transaction do
        @words = Word.where(category_id: self.category_id)
          .order("RANDOM()").limit Settings.lesson.word_per_lesson
        @words.each do |word|
          @true_answer = word.count_true_answer_for_word
          while @true_answer > 0 do
            @result = self.results.build word_id: word.id
            @true_answer -= 1
            unless @result.save!
              raise ActiveRecord::Rollback
            end
          end
        end
      end
    end
  end
end
