class ChangeColumnsOfStations < ActiveRecord::Migration
  def change
    remove_column :stations, :province
    remove_column :stations, :district
    rename_column :stations, :zhan, :description

  end
end
