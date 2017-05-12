class Word < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :results, dependent: :destroy

  validates :content, presence: true,
    length: {maximum: Settings.word.max_length_content}
  validate :validates_answers
  validates :content, uniqueness: true
  mount_uploader :picture, PictureUploader
  validate :picture_size

  LEARNT_QUERY = "content like :search and id IN (select word_id
    FROM results as r INNER JOIN lessons as l
    ON r.lesson_id = l.id WHERE l.user_id = :user_id)"

  NOT_YET_QUERY = "content like :search and id not IN (select word_id
    FROM results as r INNER JOIN lessons as l
    ON r.lesson_id = l.id WHERE l.user_id = :user_id)"

  RESULT_QUERY = "content like :search and id IN (SELECT r.word_id
    FROM results r INNER JOIN answers a
    ON r.answer_id = a.id WHERE lesson_id IN (SELECT id FROM lessons
    WHERE user_id = :user_id) and a.is_correct = :is_correct)"

  scope :recent, ->{order "created_at DESC"}
  scope :random, ->{order "RANDOM()"}

  scope :get_all, -> search {where "content LIKE ?", "%#{search}%"}
  scope :filter_category, ->category_id do
    where category_id: category_id if category_id.present?
  end

  scope :learned, -> user_id, search do
    where LEARNT_QUERY, user_id: user_id, search: "%#{search}%"
  end

  scope :not_learned, -> user_id, search do
    where NOT_YET_QUERY, user_id: user_id, search: "%#{search}%"
  end

  scope :learned_correct, ->user_id, search do
    where RESULT_QUERY, user_id: user_id, is_correct: true, search: "%#{search}%"
  end

  scope :learned_not_correct, ->user_id, search do
    where RESULT_QUERY, user_id: user_id, is_correct: false, search: "%#{search}%"
  end

  def picture_size
    if picture.size > Settings.category.picture_cate_size.megabytes
      errors.add :picture, I18n.t("admin.categories.index.picture_size_message")
    end
  end

  def find_answer
    Word.eager_load(:answers)
      .where("answers.is_correct =\"t\" and answers.word_id = ?", self.id)
  end


  private

  def validates_answers
    if answers.select{|answer| !answer._destroy}.count < Settings.answer_quanlity
      errors.add :answers, I18n.t("word.answer_quanlity_error")
    end
    if answers.detect{|answer| answer.is_correct? && !answer._destroy}.nil?
      errors.add :answers, I18n.t("word.must_has_correct_answer_error")
    end
  end
end
