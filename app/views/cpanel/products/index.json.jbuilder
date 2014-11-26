json.array!(@products) do |product|
  json.extract! product, :id, :type_id, :title, :intro, :image, :low_price, :origin_price
  json.url product_url(product, format: :json)
end
