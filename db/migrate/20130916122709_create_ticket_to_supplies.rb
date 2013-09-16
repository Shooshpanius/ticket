class CreateTicketToSupplies < ActiveRecord::Migration
  def change
    create_table :ticket_to_supplies do |t|

      t.integer :initiator_id
      t.belongs_to :group
      t.string :topic
      t.text :text
      t.date :deadline
      t.integer :completed
      t.integer :executor
      t.integer :actual
      t.integer :root

      t.timestamps
    end
  end
end
