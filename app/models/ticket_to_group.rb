class TicketToGroup < ActiveRecord::Base
  belongs_to :groups
  has_many :ticket_comments, dependent: :destroy

end
