window.App =
  alert: (msg, to) ->
    $(to).before("<div data-alert class='alert-message'><a class='close' href='#'>×</a>#{msg}</div>")
      
  updateUserState: (el) ->
    result = confirm("你确定吗？")
    if !result 
      return false
    
    id = $(el).data("id")
    state = $(el).data("state")
    
    if state == true
      url = "/cpanel/users/#{id}/block"
    else
      url = "/cpanel/users/#{id}/unblock"
      
    $.ajax
      url: url
      type: "PATCH"
      success: (re) ->
        if re == "1"
          if state == true
            $(el).data("state", false)
            $(el).text("启用")
          else
            $(el).data("state", true)
            $(el).text("禁用")
        else
          App.alert("更新失败", $(el))
    
  # 更新小区状态
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
            $(el).data("state", false)
          else 
            $(el).text("关闭")
            $(el).data("state", true)
        else
          App.alert("抱歉，系统异常", $(el))