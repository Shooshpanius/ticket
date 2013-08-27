class AddRootToTicketToUser < ActiveRecord::Migration
  def change
    add_column :ticket_to_users, :root, :integer
  end
end
