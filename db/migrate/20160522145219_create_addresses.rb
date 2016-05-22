class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :user, foreign_key: true
      t.references :city, foreign_key: true
      
      t.string :name
      t.string :street
      t.integer :number
      t.string :directions
      t.string :zip_code
    end
    
    add_index :addresses, [:user_id, :name], unique:true, name: "index_addresses_on_user_id_and_name"
    
  end
end
