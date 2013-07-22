class CreateTicketToGroups < ActiveRecord::Migration
  def change
    create_table :ticket_to_groups do |t|
      t.integer :initiator_id
      t.belongs_to :groups
      t.string :topic
      t.string :text
      t.date :deadline
      t.integer :completed
      t.timestamps
    end
  end
end
