class TicketToUser < ActiveRecord::Base
  belongs_to :user
  has_many :ticket_comments, dependent: :destroy


  after_create :send_new_user_ticket_email

  def send_new_user_ticket_email
    TicketMailer.send_new_user_ticket_email(self).deliver
  end

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
    if @user_ticket.user_id == user_id
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
      @user_comment.user_id = user_id
      @user_comment.ticket_to_user_id = ticket_id
      @user_comment.text = inputCommText
      @user_comment.save()
    end
  end


end
