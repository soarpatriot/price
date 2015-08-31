class AddStationableToStations < ActiveRecord::Migration
  def change
    add_column :stations, :stationable_id, :integer
    add_column :stations, :stationable_type, :string
  end
end
