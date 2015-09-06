class ChangeColumnTypeOfPoints < ActiveRecord::Migration
  def change
    change_column :points, :lantitude, :decimal, :precision => 15, :scale => 10
    change_column :points, :longitude, :decimal, :precision => 15, :scale => 10
  end
end
