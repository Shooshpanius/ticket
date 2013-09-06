class AddDalayToTicketRoot < ActiveRecord::Migration
  def change
    add_column :ticket_roots, :delay, :timestamp
  end
end
