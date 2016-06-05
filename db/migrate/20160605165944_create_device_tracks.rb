class CreateDeviceTracks < ActiveRecord::Migration
  def change
    create_table :device_tracks do |t|
      t.references :tracking_device, foreign_key: true, null:false
      t.string :period, null:false
      t.integer :speed_max, null:false
      t.integer :speed_p75, null:false
      t.integer :speed_avg, null:false
      t.integer :speed_p25, null:false
      t.integer :speed_min, null:false
      t.float :acceleration_up, null:false
      t.float :acceleration_down, null:false
      t.float :acceleration_forward, null:false
      t.float :acceleration_backward, null:false

      t.timestamps null: false
    end
    add_index :device_tracks, [:tracking_device_id, :period], name: 'index_device_tracks_on_tracking_device_id_and_period'
  end
end
