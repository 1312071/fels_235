module ResultsHelper
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
