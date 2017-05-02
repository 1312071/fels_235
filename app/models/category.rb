class Category < ApplicationRecord
  has_many :lessons, dependent: :destroy
  has_many :words, dependent: :destroy

  mount_uploader :picture, PictureUploader

  validates :name, presence: true, length: {maximum: Settings.max_cate_name,
    minimum: Settings.min_cate_name}, uniqueness: true
  validates :description, presence: true,
    length: {maximum: Settings.max_cate_desc}
  validate :picture_size

  private

  def picture_size
    if picture.size > Settings.picture_cate_size.megabytes
      errors.add :picture, I18n.t("admin.categories.index.picture_size_message")
    end
  end
end
