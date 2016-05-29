class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.references :version, index: true, foreign_key: true, null:false
      t.integer :year, null:false
      t.string :currency, null:false
      t.integer :price, null:false

      t.timestamps null: false
    end
    add_index :prices, ['version_id', 'year', 'currency'], name:'index_prices_by_version_id_year_and_currency'
  end
end
