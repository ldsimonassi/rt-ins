json.array!(@device_models) do |device_model|
  json.extract! device_model, :id, :gps, :obdi, :accelerometer, :camera, :computer, :name
  json.url device_model_url(device_model, format: :json)
end
