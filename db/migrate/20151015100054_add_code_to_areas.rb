class AddCodeToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :code, :string
  end
end
