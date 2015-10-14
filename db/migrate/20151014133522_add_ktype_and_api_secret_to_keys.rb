class AddKtypeAndApiSecretToKeys < ActiveRecord::Migration
  def change
    add_column :keys, :ktype, :int
    add_column :keys, :api_secret, :string
  end
end
