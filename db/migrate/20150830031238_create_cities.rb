class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :descripton
      t.float :lantitude
      t.float :langitude
      t.integer :province_id

      t.timestamps
    end
  end
end
