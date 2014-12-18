window.App =
  alert: (msg, to) ->
    $(to).before("<div data-alert class='alert-message'><a class='close' href='#'>×</a>#{msg}</div>")
  
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
          $("#order_apartment_id").attr("disabled", true)
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
  
  addToCart: (el) ->
    loading = $(el).data("loading")
    if loading == '1'
      return
    
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
      return
    
    $(el).data("loading", '1')
    
    id = $(el).data("id")
    type = $(el).data("type")
    $.ajax
      url: "/line_items/#{id}"
      type: "DELETE"
      data: { type: type }
  
  reduceQuantity: (el) ->
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