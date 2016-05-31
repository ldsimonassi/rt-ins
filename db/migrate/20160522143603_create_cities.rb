class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name, null:false
      t.references :province, foreign_key: true, null:false

      t.timestamps null: false
    end

    add_index :cities, [:province_id, :name], unique:true
  end
  
end
