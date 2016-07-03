class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :period
      t.references :tracking_device, index: true, foreign_key: true
      t.references :driver, index: true, foreign_key: true
      t.references :alert_type, index: true, foreign_key: true
      t.float :latitude
      t.float  :longitude
      t.string :additional_data
      t.timestamps null: false
    end
    add_index :alerts, [:driver_id, :period], name: 'index_alerts_by_driver_id_and_period'
    add_index :alerts, [:tracking_device_id, :period], name: 'index_alerts_by_tracking_device_id_and_period'
  end
end