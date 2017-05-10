module ResultsHelper
  def current_result_stt result
    Result.select(:word_id)
      .where("lesson_id = #{result.lesson_id} AND id <= #{result.id}").distinct
      .count
  end

  def count_true_answer result
    result.word.answers.where(is_correct: "t").count if result
  end

  def current_result lesson
    lesson.results.where("answer_id IS NULL").first
  end

  def check_answer result
    @list_answer = Result.where word_id: result.word_id,
      lesson_id: result.lesson_id
    if count_true_answer(result) != @list_answer.count
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

  def print_answer_content result
    @count = Result.where(word_id: result.word_id,
      lesson_id: result.lesson_id).count
    @str = String.new
    if @count > 1
      @list_result = Result.where word_id: result.word_id,
        lesson_id: result.lesson_id
      @list_result.each do |res|
        @str += res.answer.content + " /" if res.answer_id
      end
    else
      @str = result.answer.content if result.answer_id
    end
    return @str
  end
end
