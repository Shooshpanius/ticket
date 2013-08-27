class AddRootToTicketComments < ActiveRecord::Migration
  def change
    add_column :ticket_comments, :root, :integer
  end
end
