class ChangeTheStationLatAndLngType < ActiveRecord::Migration
  def change
    change_column :stations, :lantitude, :decimal, :precision => 15, :scale => 10
    change_column :stations, :longitude, :decimal, :precision => 15, :scale => 10
  end
end
