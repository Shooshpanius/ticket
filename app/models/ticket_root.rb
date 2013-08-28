class TicketRoot < ActiveRecord::Base

  acts_as_tree order: "id"


end
