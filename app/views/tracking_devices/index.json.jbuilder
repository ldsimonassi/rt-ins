json.array!(@tracking_devices) do |tracking_device|
  json.extract! tracking_device, :id, :serial_no, :device_model_id
  json.url tracking_device_url(tracking_device, format: :json)
end
