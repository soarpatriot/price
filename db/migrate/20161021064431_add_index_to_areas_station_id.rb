class AddIndexToAreasStationId < ActiveRecord::Migration
  def change
    add_index :areas, :station_id
  end
end
