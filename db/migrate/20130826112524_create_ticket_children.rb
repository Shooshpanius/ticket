class CreateTicketChildren < ActiveRecord::Migration
  def change
    create_table :ticket_children do |t|
      t.integer :parent_user_ticket_id
      t.integer :parent_group_ticket_id
      t.integer :children_user_ticket_id
      t.integer :children_group_ticket_id

      t.timestamps
    end
  end
end
