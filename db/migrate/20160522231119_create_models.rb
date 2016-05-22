class CreateModels < ActiveRecord::Migration
  def change
    create_table :models do |t|
      t.string :name
      t.references :brand, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :models, [:brand_id, :name], unique:true, name:'index_models_by_brand_id_and_name'
  end
end
