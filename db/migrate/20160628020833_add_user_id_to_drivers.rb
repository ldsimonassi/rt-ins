class AddUserIdToDrivers < ActiveRecord::Migration
  def change
    add_reference :drivers, :user
    add_index :drivers, [:user_id, :id], name:'index_drivers_by_user_id_and_id'
    add_index :drivers, [:user_id, :name], unique:true, name:'index_drivers_by_user_id_and_name'
  end
end
