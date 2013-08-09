class CreateTicketToUsers < ActiveRecord::Migration
  def change
    create_table :ticket_to_users do |t|
      t.integer :initiator_id
      t.belongs_to :user
      t.string :topic
      t.text :text
      t.date :deadline
      t.integer :completed
      t.boolean :actual
      t.timestamps
    end
  end
end
