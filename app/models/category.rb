class Category < ApplicationRecord
  before_destroy :check_for_lessons_words

  has_many :lessons, dependent: :destroy
  has_many :words, dependent: :destroy

  mount_uploader :picture, PictureUploader

  validates :name, presence: true,
    length: {maximum: Settings.category.max_cate_name,
    minimum: Settings.category.min_cate_name}, uniqueness: true
  validates :description, presence: true,
    length: {maximum: Settings.category.max_cate_desc}
  validate :picture_size

  private

  def picture_size
    if picture.size > Settings.category.picture_cate_size.megabytes
      errors.add :picture, I18n.t("admin.categories.index.picture_size_message")
    end
  end

  def check_for_lessons_words
    if self.lessons.any? || self.words.any?
      errors.add :base, I18n.t("admin.categories.index.delete_error_message")
      throw(:abort) if errors.present?
    end
  end
end
