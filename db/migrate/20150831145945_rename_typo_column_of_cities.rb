class RenameTypoColumnOfCities < ActiveRecord::Migration
  def change
    rename_column :cities, :descripton, :description
  end
end
