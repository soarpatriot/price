class RenameTypoColumnOfProvinces < ActiveRecord::Migration
  def change
    rename_column :provinces, :descripton, :description
  end
end
