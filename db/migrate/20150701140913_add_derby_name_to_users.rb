class AddDerbyNameToUsers < ActiveRecord::Migration
  def change
      add_column :users, :derby_name, :string
  end
end
