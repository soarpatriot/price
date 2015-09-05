class RenameColumnsOfAreas < ActiveRecord::Migration
  def change
    rename_column :areas, :lable, :label
  end
end
