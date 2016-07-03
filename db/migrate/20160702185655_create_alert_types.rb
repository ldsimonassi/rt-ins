class CreateAlertTypes < ActiveRecord::Migration
  def change
    create_table :alert_types do |t|
      t.string :alert_type, null: false
      t.string :description, null: false

      t.timestamps null: false
    end
    add_index :alert_types, :alert_type, unique:true
  end
end
