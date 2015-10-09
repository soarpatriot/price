class RenameAppKeyOfKey < ActiveRecord::Migration
  def change
    rename_column :keys, :app_key, :api_key
  end
end
