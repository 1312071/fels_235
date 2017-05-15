class Result < ApplicationRecord
  belongs_to :answer, optional: true
  belongs_to :word
  belongs_to :lesson

  scope :sort_by_created, ->{order created_at: :asc}

  scope :result_next, ->id, word_id{where("id > #{id} AND word_id <> #{word_id}").first}

  def current_result_index
    Result.select(:word_id)
      .where("lesson_id = #{self.lesson_id} AND id <= #{self.id}")
      .distinct.count
  end

  def count_true_answer
    word.answers.where(is_correct: "t").count
  end

  def check_answer
    @list_answer = Result.where word_id: self.word_id,lesson_id: self.lesson_id
    if self.count_true_answer != @list_answer.count
      false
    else
      @list_answer.each do |result|
        if result.answer_id.nil?
          false
        else
          if Answer.find_by(id: result.answer_id).is_correct?
            true
          else
            false
          end
        end
      end
    end
  end

  def update_attributes_answer count_answer
    @result = self
    @count = count_answer.length
    while @count > @result.count_true_answer do
      Result.create answer_id: count_answer[@count - 1],
        word_id: @result.word_id, lesson_id: @result.lesson_id
      @count -= 1
    end
    while @count > 0 do
      @result.update_attributes answer_id: count_answer[@count - 1]
      unless @count == Settings.result.single_answer
        @result = Result.where("id > #{@result.id}").first
      end
      @count -= 1
    end
  end
end
