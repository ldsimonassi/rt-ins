class AddPassphraseToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :passphrase, :string
  end
end
