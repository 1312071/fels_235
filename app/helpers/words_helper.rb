module WordsHelper
  def count_true_answer_for_word word
    word.answers.where(is_correct: "t").count
  end
end
