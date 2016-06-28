class AddIndexToDriversOnUserIdAndInternalId < ActiveRecord::Migration
  def change
  	add_index :drivers, [:user_id, :internal_id], unique:true, name: 'index_drivers_by_user_id_and_internal_id'
  end
end
