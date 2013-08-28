class AddRootToTicketChildren < ActiveRecord::Migration
  def change
    add_column :ticket_children, :parent_id, :integer
    add_column :ticket_children, :child_id, :integer
  end
end
