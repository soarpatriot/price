class RenameStatonColumnFromOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :order_station_id, :station_id
    rename_column :orders, :order_station, :station_name
  end
end
