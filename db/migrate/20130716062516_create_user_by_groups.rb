class CreateUserByGroups < ActiveRecord::Migration
  def change
    create_table :user_by_groups do |t|

      t.belongs_to :users
      t.belongs_to :groups
      t.timestamps
    end
  end
end
