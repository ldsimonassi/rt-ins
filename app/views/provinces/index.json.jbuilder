json.array!(@provinces) do |province|
  json.extract! province, :id, :country_id, :name
  json.url province_url(province, format: :json)
end
