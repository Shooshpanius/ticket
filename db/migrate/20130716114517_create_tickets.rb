class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|

      t.integer :initiator_id
      t.integer :executor_id
      t.integer :executor_type
      t.string :topic
      t.string :text
      t.date :deadline

      t.timestamps
    end
  end
end
