class TicketToUser < ActiveRecord::Base
  belongs_to :users
  has_many :ticket_comments, :foreign_key => :ticket_to_user_id, dependent: :destroy

end
