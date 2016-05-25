class CreateExpressAreas < ActiveRecord::Migration
  def change
    create_table :express_areas do |t|
      t.integer :expressman_id
      t.integer :area_id

      t.timestamps
    end
  end
end
