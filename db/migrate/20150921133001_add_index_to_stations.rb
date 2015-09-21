class AddIndexToStations < ActiveRecord::Migration
  def change
    add_index :stations, :description,                unique: true
  end
end
