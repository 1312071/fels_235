class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  process resize_to_limit: [Settings.category.picture_cate_width,
    Settings.category.picture_cate_height]

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def default_url *args
    "fallback/" + [version_name, "default.png"].compact.join("_")
  end
end
