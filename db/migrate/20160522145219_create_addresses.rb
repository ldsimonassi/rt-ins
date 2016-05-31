class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :user, foreign_key: true, null:false
      t.references :city, foreign_key: true, null:false
      
      t.string :name, null:false
      t.string :street, null:false
      t.integer :number, null:false
      t.string :directions
      t.string :zip_code, null:false
    end
    
    add_index :addresses, [:user_id, :name], unique:true, name: "index_addresses_on_user_id_and_name"
    
  end
end
