# encoding: utf-8

class BannerUploader < BaseUploader

  version :small do
    process resize_to_fill: [81, 40]
  end
  
  version :normal do
    process resize_to_fill: [1920, 360]
  end

  def filename
    if super.present?
      "avatar/#{Time.now.to_i}.#{file.extension.downcase}"
    end
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

end
