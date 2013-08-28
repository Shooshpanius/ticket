class AddParentIdToTicketRoot < ActiveRecord::Migration
  def change
    add_column :ticket_roots, :parent_id, :integer
  end
end
