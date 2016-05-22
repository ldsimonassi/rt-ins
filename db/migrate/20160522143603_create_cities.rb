class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.references :province, foreign_key: true

      t.timestamps null: false
    end

    add_index :cities, [:province_id, :name], unique:true
  end
  
end
