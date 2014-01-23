class AddSchedulerToTicketToUser < ActiveRecord::Migration
  def change
    add_column :ticket_to_users, :in_scheduler, :boolean
    add_column :ticket_to_users, :start_scheduler, :integer
    add_column :ticket_to_users, :stop_scheduler, :integer
  end
end
