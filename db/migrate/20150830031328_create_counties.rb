class CreateCounties < ActiveRecord::Migration
  def change
    create_table :counties do |t|
      t.string :descripton
      t.float :lantitude
      t.float :langitude
      t.integer :city_id

      t.timestamps
    end
  end
end
