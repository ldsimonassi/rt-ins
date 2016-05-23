class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string :name, null:false
      t.references :model, index: true, foreign_key: true
      t.timestamps null: false
    end

    add_index :versions, [:model_id, :name], name: 'index_versions_by_model_id_and_name', unique: true
  end
end
