window.App =
  alert: (msg, to) ->
    $(to).before("<div data-alert class='alert-message'><a class='close' href='#'>×</a>#{msg}</div>")
  
  doSaveAddress: (el) ->
    id = $(el).data("user-id")
    address = $("#order_apartment_id").val()
    if address == ''
      return
    alert(address)
    $.ajax
      url: "/users/#{id}/update_address"
      type: "PATCH"
      data: { address: "#{address}" }
      # success: (re) ->
        # alert(re)
        # $('.address-html-container').html(re)
    
  checkValue: (el) ->
    reg = /^[+]?(([1-9]\d*[.]?)|(0.))(\d{0,2})?$/
    value = $(el).val()
    
    if value.length > 0 and !value.match(reg)
      $(el).val(1)
    
  doWeight: (el) ->
    id = $(el).data("id")
    type = $(el).data("type")
    weight = $("#product-weight-#{id}").val()
    weight = parseInt(weight)
    if type == '+'
      weight += 1
    else
      weight -= 1
      if weight == 0
        weight = 1
    $("#product-weight-#{id}").val(weight)
  
  # 新建订单
  createOrder: (el) ->
    
  # 取消订单
  cancelOrder: (el) ->
    result = confirm("您确定吗？")
    if !result
      return false
    
    id = $(el).data("id")
    current = $(el).data("current")
    
    $.ajax
      url: "/orders/#{id}/cancel"
      type: "PATCH"
    
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