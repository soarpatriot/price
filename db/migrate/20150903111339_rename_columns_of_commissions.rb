class RenameColumnsOfCommissions < ActiveRecord::Migration
  def change
    rename_column :commissions, :description, :name
  end
end
