# coding: utf-8
module ApplicationHelper
  def render_page_title
    site_name = "水果社"
    title = @page_title ? "#{site_name} - #{@page_title}" : site_name rescue "SITE_NAME"
    content_tag("title", title, nil, false)
  end
  
  def notice_message
    flash_messages = []
    flash.each do |type, message|
      type = :success if type.to_s == "notice"
      type = :warning if type.to_s == "alert"
      type = :danger if type.to_s == "error"
      text = content_tag(:div, link_to("×", "#", class: "close", 'data-dismiss' => "alert") + message, class: "alert alert-#{type}")
      flash_messages << text if message
    end
    flash_messages.join("\n").html_safe
  end
  
  def owner?(item)
    return false if item.blank?
    return item.user == current_user
  end
  
  # state: true, yes_uri: "/cpanel/users/1/block", yes_text: "禁用", no_uri: "/cpanel/users/1/unblock", no_text: "启用"
  def state_link_to(opts = {})
    state = opts[:state]

    message = if state 
      opts[:yes_text]
    else
      opts[:no_text]
    end
    
    html = <<-HTML
    <a href="#" data-remote="true" 
                data-yes-uri="#{opts[:yes_uri]}" 
                data-yes-text="#{opts[:yes_text]}" 
                data-no-uri="#{opts[:no_uri]}" 
                data-no-text="#{opts[:no_text]}"
                data-state="#{state}"
                onclick="App.updateState(this);" 
                class="btn btn-danger btn-xs" >
                #{message}
    </a>
    HTML
    
    html.html_safe
  end
  
  def render_grid_for(collection, cell_count = 3)
    html = ""
    collection.each_with_index do |item, index|
      if index % cell_count == 0
        html += '<div class="row">'
      end
      
      html += render item
      
      if index % cell_count == cell_count -1 or index == collection.size - 1
        html += '</div>'
      end
    end
    html.html_safe
  end
  
end
