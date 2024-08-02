class BookImageUploader < CarrierWave::Uploader::Base
  storage :file

  # 画像の拡張子の許可
  def extension_whitelist
    %w(jpg jpeg png)
  end
end
