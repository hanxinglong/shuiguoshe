window.App =
  alert: (msg, to) ->
    $(to).before("<div class='alert alert-danger'><a class='close' href='#' data-dismiss='alert'>×</a>#{msg}</div>")
  
  notice: (msg, to) ->
    $(to).before("<div class='alert alert-success'><a class='close' href='#' data-dismiss='alert'>×</a>#{msg}</div>")
  
  doSaveAddress: (el) ->
    id = $(el).data("user-id")
    address = $("#order_apartment_id").val()
    if address == ''
      return
    $.ajax
      url: "/users/#{id}/update_address"
      type: "PATCH"
      data: { address: "#{address}" }
      success: (re) ->
        if re == "1"
          # alert($("#user-edit-apartment").html());
          $("#edit-user-apartment").html("<a onclick='updateApartment()' class='btn btn-sm btn-success'>修改</a>")
          # $("#order_apartment_id").attr("disabled", true)
          $('#order_apartment_id').prop('disabled', true).trigger("chosen:updated");
          $("#order_apartment_id").data("current", address)
          # alert($("#user-edit-apartment").html());
          $("#order_apartment_id option").attr("user-apartment-id", address)
          $("#hide_order_apartment_input").html("<input type=\"hidden\" name=\"order[apartment_id]\" value=\"#{address}\" />")
        else
          $("#order_apartment_id option").attr("user-apartment-id", '')
          App.alert("操作失败", $("#edit-user-apartment"))
          # body...
        # alert(re)
        # $('.address-html-container').html(re)
        
  getCode: (el) ->
    if $(el).data("loading") == '1'
      return false
      
    mobile = $("#user_mobile").val()
    blank_mobile = mobile.replace(/\s+/, "")
    if blank_mobile.length == 0
      App.alert("手机号不能为空", $('#new_user'))
      return false
      
    reg = /^1[3|4|5|8][0-9]\d{4,8}$/
    if not reg.test(mobile)
      App.alert("不正确的手机号", $('#new_user'))
      return false
      
    $(el).attr("disabled", true)
    $(el).data("loading", '1')
    $(el).text('59秒后重新获取')
    total = 58
    setTimeout (f = (->
      if total == -1
        clearInterval(f)
        $(el).removeAttr("disabled")
        $(el).text("获取验证码")
        $(el).data("loading", '0')
        return
      $(el).text((total--) + '秒后重新获取')
      setTimeout(f, 1000)
      
        
    )), 1000
    # setTimeout =>

    #     , 1000
    
    $.ajax
      url: "http://shuiguoshe.com/api/v1/auth_codes"
      type: "POST"
      data: { mobile: mobile, type: parseInt($("#user_code_type").val()) }
      success: (re) -> 
        # $(el).removeAttr("disabled")
        if re.code == 0
          App.notice("获取验证码成功", $('#new_user'))
        else
          App.alert(re.message, $('#new_user'))
  
  addToCart: (el) ->
    loading = $(el).data("loading")
    if loading == '1'
      return false
    
    $(el).data("loading", '1')
    
    pid = $(el).data("product-id")
    $.ajax
      url: "/line_items"
      type: "POST"
      data: { product_id: "#{pid}" }
      success: (re) ->
        if re == "1"
          
        else
          
    
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
  
  deleteItem: (el) ->
    # result = confirm("您确定吗？")
    # if !result
    #   return false
    
    loading = $(el).data("loading")
    if loading == '1'
      return false
    
    $(el).data("loading", '1')
    
    id = $(el).data("id")
    type = $(el).data("type")
    $.ajax
      url: "/line_items/#{id}"
      type: "DELETE"
      data: { type: type }
  
  reduceQuantity: (el) ->
    
    loading = $(el).data("loading")
    if loading == '1'
      return false
    
    $(el).data("loading", '1')
    
    id = $(el).data("id")
    item = $("#line_item_quantity_#{id}")
    quantity = item.text()
    quantity = parseInt(quantity)
    
    if quantity == 1
      $(el).attr("disabled", true)
      return
    
    quantity -= 1
    item.text(quantity)

    $.ajax
      url: "/line_items/#{id}"
      type: "PATCH"
      data: { type: '-1' }
          
  increaseQuantity: (el) ->
    
    loading = $(el).data("loading")
    if loading == '1'
      return false
    
    $(el).data("loading", '1')
    
    id = $(el).data("id")
    item = $("#line_item_quantity_#{id}")
    quantity = item.text()
    quantity = parseInt(quantity)    
    quantity += 1
    item.text(quantity)
    
    $.ajax
      url: "/line_items/#{id}"
      type: "PATCH"
      data: { type: '1' }
          
  # 新建订单
  createOrder: (el) ->
    
  # 取消订单
  cancelOrder: (el) ->
    result = confirm("您确定吗？")
    if !result
      return false
      
    loading = $(el).data("loading")
    if loading == '1'
      return false
    
    $(el).data("loading", '1')
    
    id = $(el).data("id")
    current = $(el).data("current")
    
    $.ajax
      url: "/orders/#{id}/cancel"
      type: "PATCH"
      data: { 'current': current }
    
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