class CreateTicketRoots < ActiveRecord::Migration
  def change
    create_table :ticket_roots do |t|
      t.string :ticket_type
      t.integer :ticket_id
      t.integer :from_id
      t.integer :to_id
      t.timestamps
    end
  end
end
