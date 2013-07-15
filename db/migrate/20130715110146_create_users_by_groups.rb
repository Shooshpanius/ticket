class CreateUsersByGroups < ActiveRecord::Migration
  def change
    create_table :users_by_groups do |t|

      t.belongs_to :users
      t.belongs_to :groups
      t.timestamps
    end
  end
end
