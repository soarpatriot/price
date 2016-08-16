class AddEtypeToExpressmen < ActiveRecord::Migration
  def change
    add_column :expressmen, :etype, :integer, default: 0
  end
end
