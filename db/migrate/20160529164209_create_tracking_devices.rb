class CreateTrackingDevices < ActiveRecord::Migration
  def change
    create_table :tracking_devices do |t|
      t.string :serial_no, null:false
      t.references :device_model, index: true, foreign_key: true, null:false

      t.timestamps null: false
    end

    add_index :tracking_devices, :serial_no, unique:true
  end
end
