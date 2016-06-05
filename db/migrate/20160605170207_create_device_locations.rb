class CreateDeviceLocations < ActiveRecord::Migration
  def change
    create_table :device_locations do |t|
      t.references :tracking_device, foreign_key: true
      t.string :period
      t.float :latitude
      t.float	 :longitude

      t.timestamps null: false
    end
    add_index :device_locations, [:tracking_device_id, :period], name: 'index_device_locations_on_tracking_device_id_and_period'
  end
end
