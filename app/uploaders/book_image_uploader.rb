class BookImageUploader < CarrierWave::Uploader::Base
  storage :file

  # 保存先のディレクトリを指定する
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/book_image/#{model.id}"
  end
  # 画像の拡張子の許可
  def extension_whitelist
    %w(jpg jpeg png)
  end
end
