class CreateUserByGroups < ActiveRecord::Migration
  def change
    create_table :user_by_groups do |t|

      t.belongs_to :user
      t.belongs_to :group
      t.timestamps
    end
  end
end
