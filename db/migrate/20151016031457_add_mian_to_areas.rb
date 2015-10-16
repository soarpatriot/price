class AddMianToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :mian, :decimal, :precision => 20, :scale => 5
  end
end
