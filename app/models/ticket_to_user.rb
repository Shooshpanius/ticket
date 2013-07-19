class TicketToUser < ActiveRecord::Base
  belongs_to :users
  has_many :ticket_comments, :foreign_key => :ticket_to_user_id, dependent: :destroy

  def TicketToUser.is_initiator(user_id, ticket_id)
    @user_ticket = TicketToUser.find(ticket_id)
    if @user_ticket.initiator_id == user_id
      return true
    else
      return false
    end
  end

  def TicketToUser.is_executor(user_id, ticket_id)
    @user_ticket = TicketToUser.find(ticket_id)
    if @user_ticket.users_id == user_id
      return true
    else
      return false
    end
  end


  def TicketToUser.change_status(user_id, status, ticket_id)
    if TicketToUser.is_initiator(user_id, ticket_id) or TicketToUser.is_executor(user_id, ticket_id)
      @user_ticket = TicketToUser.find(ticket_id)
      @user_ticket.completed = status
      @user_ticket.save
    end
  end

  def TicketToUser.comment_new(user_id, ticket_id, inputCommText)
    if TicketToUser.is_initiator(user_id, ticket_id) or TicketToUser.is_executor(user_id, ticket_id)
      @user_comment = TicketComment.new()
      @user_comment.users_id = user_id
      @user_comment.ticket_to_user_id = ticket_id
      @user_comment.text = inputCommText
      @user_comment.save()
    end
  end


end
