class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :country, foreign_key: true, null:false
      t.string :username, null:false
      t.string :email, null:false
      t.string :first_name, null:false
      t.string :last_name, null:false
      t.string :password_digest, null:false
      t.timestamps null: false
    end
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
