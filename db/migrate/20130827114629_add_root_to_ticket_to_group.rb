class AddRootToTicketToGroup < ActiveRecord::Migration
  def change
    add_column :ticket_to_groups, :root, :integer
  end
end
