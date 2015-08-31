class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :province
      t.string :district
      t.string :zhan
      t.text :address
      t.float :lantitude
      t.float :langitude
      t.integer :status

      t.timestamps
    end
  end
end
