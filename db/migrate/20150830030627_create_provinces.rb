class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
      t.string :descripton
      t.float :lantitude
      t.float :langitude
      t.integer :count

      t.timestamps
    end
  end
end
