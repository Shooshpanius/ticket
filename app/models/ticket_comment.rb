class TicketComment < ActiveRecord::Base

  belongs_to :ticket_to_group
  belongs_to :ticket_to_user

end
