class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :name, null:false

      t.references :price, foreign_key: true, null:false
      t.references :user, index: true, foreign_key: true, null:false
      t.references :country, foreign_key:true, null:false

      t.references :tracking_device, null:false, foreign_key:true
      
      t.string :chasis_no, null:false
      t.string :engine_no, null:false
      t.string :plate_no, null:false

      t.timestamps null: false
    end

    add_index :vehicles, :tracking_device_id, unique:true
    add_index :vehicles, [:country_id, :chasis_no], unique:true, name: 'index_vehicles_on_country_id_and_chasis_no'
    add_index :vehicles, [:country_id, :engine_no], unique:true, name: 'index_vehicles_on_country_id_and_engine_no'
    add_index :vehicles, [:country_id, :plate_no], unique:true, name: 'index_vehicles_on_country_id_and_plate_no'
  end
end