class CreateTicketToUsers < ActiveRecord::Migration
  def change
    create_table :ticket_to_users do |t|
      t.integer :initiator_id
      t.belongs_to :user
      t.string :topic
      t.string :text
      t.date :deadline
      t.integer :completed
      t.timestamps
    end
  end
end
