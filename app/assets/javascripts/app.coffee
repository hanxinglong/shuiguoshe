window.App =
  alert: (msg, to) ->
    $(to).before("<div data-alert class='alert-message'><a class='close' href='#'>×</a>#{msg}</div>")
    
  # 更新状态
  updateState: (el) ->
    result = confirm("你确定吗?")
    if !result
      return false
    
    state = $(el).data("state")
    
    if state == true
      url = $(el).data("yes-uri")
    else
      url = $(el).data("no-uri")
      
    $.ajax
      url: url
      type: "PATCH"
      success: (re) ->
        if re == "1"
          if state == true
            $(el).text($(el).data("no-text"))
            $(el).data("state", false)
          else 
            $(el).text($(el).data("yes-text"))
            $(el).data("state", true)
        else
          App.alert("抱歉，系统异常", $(el))