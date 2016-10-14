class AddExpressmanCodeToGuoGuoLog < ActiveRecord::Migration
  def change
    add_column :guo_guo_logs, :expressman_code, :string
    add_column :guo_guo_logs, :expressman_name, :string
    add_column :guo_guo_logs, :expressman_mobile, :string
  end
end
