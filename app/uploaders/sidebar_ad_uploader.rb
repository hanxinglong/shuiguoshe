# encoding: utf-8

class SidebarAdUploader < BaseUploader

  version :small do
    process resize_to_limit: [131, nil]
  end
  
  version :normal do
    process resize_to_limit: [262, nil]
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
