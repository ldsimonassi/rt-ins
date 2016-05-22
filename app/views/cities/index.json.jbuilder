json.array!(@cities) do |city|
  json.extract! city, :id, :name, :province_id
  json.url city_url(city, format: :json)
end
