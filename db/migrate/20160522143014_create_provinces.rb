class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
      t.references :country, foreign_key: true, null:false
      t.string :name
      t.timestamps null: false
    end
    
    add_index :provinces, [:country_id, :name], unique:true
  end
end
