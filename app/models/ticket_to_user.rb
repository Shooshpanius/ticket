class TicketToUser < ActiveRecord::Base
  belongs_to :users
  has_many :ticket_comments, dependent: :destroy

end
