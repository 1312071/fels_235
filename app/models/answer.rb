class Answer < ApplicationRecord
  belongs_to :word, optional: true
  has_many :results, dependent: :destroy
  scope :correct, -> {where is_correct: true}
end
