class CreateManMessages < ActiveRecord::Migration
  def change
    create_table :man_messages do |t|
      t.integer :is_success
      t.string :status_message
      t.string :courier_name
      t.string :courier_mobile
      t.string :account_id
      t.string :employee_no

      t.timestamps
    end
  end
end
