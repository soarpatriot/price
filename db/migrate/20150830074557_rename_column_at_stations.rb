class RenameColumnAtStations < ActiveRecord::Migration
  def change
    rename_column :stations, :langitude, :longitude
  end
end
