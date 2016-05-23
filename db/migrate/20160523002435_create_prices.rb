class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.references :version, index: true, foreign_key: true
      t.integer :year
      t.string :currency
      t.integer :price

      t.timestamps null: false
    end
    add_index :prices, ['version_id', 'year', 'currency'], unique:true, name:'index_prices_by_version_id_year_and_currency'
  end
end
