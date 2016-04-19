class CreateDensities < ActiveRecord::Migration
  def change
    create_table :densities do |t|
      t.integer :area_id
      t.integer :count
      t.integer :year
      t.integer :month

      t.timestamps
    end
    add_index :densities, :area_id
    add_index :densities, :year
    add_index :densities, :month
 
  end
end
