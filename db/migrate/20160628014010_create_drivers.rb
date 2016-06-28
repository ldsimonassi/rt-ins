class CreateDrivers < ActiveRecord::Migration
  def change
    create_table :drivers do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end