class AddStypeToStations < ActiveRecord::Migration
  def change
    add_column :stations, :stype, :integer, default: 0
  end
end
