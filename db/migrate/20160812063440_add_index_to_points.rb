class AddIndexToPoints < ActiveRecord::Migration
  def change
    add_index :points, :pointable_id
    add_index :points, :pointable_type
  end
end
