class AddIndexToStations < ActiveRecord::Migration
  def change
    add_index :stations, :description
  end
end
