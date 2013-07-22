class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|

      t.string :name
      t.string :ticket_email
      t.integer :leader

      t.timestamps
    end
  end
end
