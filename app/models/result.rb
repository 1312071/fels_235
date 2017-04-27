class Result < ApplicationRecord
  belongs_to :answer
  belongs_to :word
  belongs_to :lesson
end
