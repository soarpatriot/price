class AddColumnToArea < ActiveRecord::Migration
  def change
    add_column :areas, :commission_id, :integer
  end
end
