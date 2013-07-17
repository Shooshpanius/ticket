class CreateTicketToUsers < ActiveRecord::Migration
  def change
    create_table :ticket_to_users do |t|
      t.belongs_to :users
      t.string :topic
      t.string :text
      t.date :deadline
      t.timestamps
    end
  end
end
