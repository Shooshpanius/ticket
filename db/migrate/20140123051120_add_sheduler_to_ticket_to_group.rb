class AddShedulerToTicketToGroup < ActiveRecord::Migration
  def change
    add_column :ticket_to_groups, :in_scheduler, :boolean
    add_column :ticket_to_groups, :start_scheduler, :integer
    add_column :ticket_to_groups, :stop_scheduler, :integer
  end
end
