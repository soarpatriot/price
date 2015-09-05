class CreateCommissions < ActiveRecord::Migration
  def change
    create_table :commissions do |t|
      t.string :description
      t.float :price

      t.timestamps
    end
  end
end
