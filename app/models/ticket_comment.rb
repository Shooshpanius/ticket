class TicketComment < ActiveRecord::Base

  belongs_to :ticket_to_groups
  belongs_to :ticket_to_users

end
