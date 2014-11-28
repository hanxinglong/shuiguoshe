# coding: utf-8
module UsersHelper
  def user_avatar_tag(user,size = :normal, opts = {})
    return "" if user.blank?
    
    link = opts[:link] || false
    width = user_avatar_width_for_size(size)
    
    if user.avatar.blank?
      default_url = asset_path("avatar/#{size}.png")
      img = image_tag(default_url, alt: "用户头像", class: "img-circle")
    else
      img = image_tag(user.avatar.url(size), alt: "用户头像", class: "img-circle")
    end
    
    if link
      raw %(<a href="#{user_path(user)}">#{img}</a>)
    else
      raw img
    end
    
  end
  
  def user_avatar_width_for_size(size)
    case size
    when :normal then 48
    when :small then 16
    when :large then 64
    when :big then 120
    else 48
    end
  end
  
end