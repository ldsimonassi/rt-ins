class CreateDeviceModels < ActiveRecord::Migration
  def change
    create_table :device_models do |t|
      t.string :gps, null:false
      t.string :obdi, null:false
      t.string :accelerometer, null:false
      t.string :camera, null:false
      t.string :computer, null:false
      t.string :name, null:false
      t.string :manufacturer, null:false

      t.timestamps null: false
    end
  end
end
