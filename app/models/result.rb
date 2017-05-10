class Result < ApplicationRecord
  belongs_to :answer, optional: true
  belongs_to :word
  belongs_to :lesson

  scope :sort_by_created, ->{order created_at: :asc}

  def current_result_stt
    Result.select(:word_id)
      .where("lesson_id = #{self.lesson_id} AND id <= #{self.id}").distinct
      .count
  end

  def count_true_answer
    self.word.answers.where(is_correct: "t").count
  end

  def check_answer
    @list_answer = Result.where word_id: self.word_id,
      lesson_id: self.lesson_id
    if self.count_true_answer != @list_answer.count
      return false
    else
      @list_answer.each do |res|
        if res.answer_id.nil?
          return false
        else
          return false unless Answer.find_by(id: res.answer_id).is_correct?
        end
      end
    end
    return true
  end

  def update_answer count_answer
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
