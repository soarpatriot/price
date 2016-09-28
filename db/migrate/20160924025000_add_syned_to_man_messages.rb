class AddSynedToManMessages < ActiveRecord::Migration
  def change
    add_column :expressmen, :syned, :integer, default: 0
  end
end
