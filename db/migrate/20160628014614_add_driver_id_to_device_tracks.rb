class AddDriverIdToDeviceTracks < ActiveRecord::Migration
  def change
    add_reference :device_tracks, :driver
    add_index :device_tracks, [:driver_id, :period, :tracking_device_id], name: 'index_device_tracks_by_driver_id_tracking_device_id_and_period'
  end
end
