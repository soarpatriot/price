class AddStationIdToExpressmen < ActiveRecord::Migration
  def change
    add_column :expressmen, :station_id, :integer
  end
end
