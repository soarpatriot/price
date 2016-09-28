class AddSynedToManMessagesNew < ActiveRecord::Migration
  def change
    add_column :man_messages, :syned, :integer, default: 0
  end
end
