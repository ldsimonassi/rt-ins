class AddDriverIdToDeviceLocations < ActiveRecord::Migration
  def change
    add_reference :device_locations, :driver, null:false, default:0
    add_index :device_locations, [:driver_id, :period, :tracking_device_id], name:'index_device_locations_by_driver_id_period_and_trk'
  end
end
