class CreateUsersByGroups < ActiveRecord::Migration
  def change
    create_table :users_by_groups do |t|

      t.belongs_to :users
      t.belongs_to :groups
      t.integer :user_id
      t.integer :group_id
      t.timestamps
    end
  end
end
