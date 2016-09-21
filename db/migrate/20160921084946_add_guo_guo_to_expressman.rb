class AddGuoGuoToExpressman < ActiveRecord::Migration
  def change
    add_column :expressmen, :guoguo, :integer
  end
end
