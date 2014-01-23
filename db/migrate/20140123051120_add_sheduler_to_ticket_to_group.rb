class AddShedulerToTicketToGroup < ActiveRecord::Migration
  def change
    add_column :ticket_to_groups, :in_scheduler, :boolean
    add_column :ticket_to_groups, :start_scheduler, :datetime
    add_column :ticket_to_groups, :stop_scheduler, :datetime
  end
end
