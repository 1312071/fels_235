class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def default_url *args
    "#{Rails.root}/app/assets/images/fallback/" +
      [version_name, "default.png"].compact.join("_")
  end
end
