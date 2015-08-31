class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.integer :station_id
      t.float :price
      t.string :lable

      t.timestamps
    end
  end
end
