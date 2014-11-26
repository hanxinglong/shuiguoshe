window.App =
  alert: (msg, to) ->
    $(to).before("<div data-alert class='alert-message'><a class='close' href='#'>×</a>#{msg}</div>")
      
  updateState: (el) ->
    result = confirm("你确定吗?")
    if !result
      return false
    
    id = $(el).data("id")
    type = $(el).data("type")
    state = $(el).data("state")
    
    if state == true
      url = "/cpanel/#{type}/#{id}/close"
    else
      url = "/cpanel/#{type}/#{id}/open"
    $.ajax
      url: url
      type: "PATCH"
      success: (re) ->
        if re == "1"
          if state == true
            $(el).text("开放")
          else 
            $(el).text("关闭")
        else
          App.alert("抱歉，系统异常", $(el))