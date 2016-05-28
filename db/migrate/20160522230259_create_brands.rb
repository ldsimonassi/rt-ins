class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.references :country, index:true, foreign_key:true
      t.string :name, null:false
      t.timestamps null: false
    end

    add_index :brands, [:country_id, :name], unique:true, name: 'index_brands_by_country_id_and_name'
  end
end
