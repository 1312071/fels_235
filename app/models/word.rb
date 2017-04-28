class Word < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :results, dependent: :destroy
  validates :content, presence: true
  def find_answer
    Word.eager_load(:answers)
      .where("answers.is_correct =\"t\" and answers.word_id = ?", self.id)
  end
end
