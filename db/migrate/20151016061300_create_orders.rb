class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :order_station
      t.integer :order_station_id
      t.decimal :latitude, :precision => 15, :scale => 10
      t.decimal :longitude, :precision => 15, :scale => 10 
      t.integer :area_id
      t.decimal :price, :precision => 10, :scale => 2
      t.integer:status

      t.timestamps
    end
  end
end
