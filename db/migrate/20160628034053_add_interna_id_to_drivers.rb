class AddInternaIdToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :internal_id, :string, null:false, default:'1'
  end
end
