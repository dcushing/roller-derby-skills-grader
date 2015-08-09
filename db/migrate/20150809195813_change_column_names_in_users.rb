class ChangeColumnNamesInUsers < ActiveRecord::Migration
  def change
      rename_column :users, :name, :display_name
      rename_column :users, :derby_name, :alternate_name
  end
end
