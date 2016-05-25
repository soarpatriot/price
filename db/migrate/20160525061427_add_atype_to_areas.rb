class AddAtypeToAreas < ActiveRecord::Migration
  def change
    add_column :areas, :atype, :integer, default: 0
  end
end
