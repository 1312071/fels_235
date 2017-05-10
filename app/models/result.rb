class Result < ApplicationRecord
  belongs_to :answer, optional: true
  belongs_to :word
  belongs_to :lesson

  scope :sort_by_created, -> {order created_at: :asc}
end
