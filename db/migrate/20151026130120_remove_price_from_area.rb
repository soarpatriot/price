class RemovePriceFromArea < ActiveRecord::Migration
  def change
    remove_column :areas,:price
  end
end
