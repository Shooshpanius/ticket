class CreateTicketRoots < ActiveRecord::Migration
  def change
    create_table :ticket_roots do |t|
      t.string :type
      t.integer :ticket_id
      t.timestamps
    end
  end
end
