class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name
      t.integer :level
      t.text :comments
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :skills, :users
  end
end
