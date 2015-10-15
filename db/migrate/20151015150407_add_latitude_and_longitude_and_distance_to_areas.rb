class AddLatitudeAndLongitudeAndDistanceToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :latitude, :decimal, :precision => 15, :scale => 10
    add_column :areas, :longitude, :decimal, :precision => 15, :scale => 10
    add_column :areas, :distance, :integer
 
  end
end
