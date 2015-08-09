class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :league, :string
    add_column :users, :blocker, :boolean
    add_column :users, :jammer, :boolean
    add_column :users, :freshmeat, :boolean
    add_column :users, :ref, :boolean
    add_column :users, :nso, :boolean
  end
end
