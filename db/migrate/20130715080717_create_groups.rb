class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|

      t.string :name
      t.string :users
      t.string :ticket_email

      t.timestamps
    end
  end
end
