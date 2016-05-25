class CreateExpressmen < ActiveRecord::Migration
  def change
    create_table :expressmen do |t|
      t.string :name
      t.string :mobile
      t.string :code

      t.timestamps
    end
  end
end
