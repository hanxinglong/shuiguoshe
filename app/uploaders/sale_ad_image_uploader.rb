# encoding: utf-8

class SaleAdImageUploader < BaseUploader

  version :small do
    process resize_to_limit: [nil, 60]
  end
  
  version :normal do
    process resize_to_limit: [nil, 360]
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
