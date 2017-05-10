module ResultsHelper
  def print_answer_content result
    @count = Result.where(word_id: result.word_id,
      lesson_id: result.lesson_id).count
    if @count > Settings.result.single_answer
      @list_result = Result.where word_id: result.word_id,
        lesson_id: result.lesson_id
      @list_result.each do |result|
        @string += result.answer.content + " /" if result.answer_id
      end
    else
      @string = result.answer.content if result.answer_id
    end
  end
end
