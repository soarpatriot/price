class CreateGuoGuoLogs < ActiveRecord::Migration
  def change
    create_table :guo_guo_logs do |t|
      t.integer :user_id
      t.string :user_name
      t.string :user_code
      t.integer :gtype
      t.integer :expressman_id
      t.timestamps
    end
  end
end
