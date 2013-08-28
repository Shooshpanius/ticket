class TicketToUser < ActiveRecord::Base
  belongs_to :user
  has_many :ticket_comments, dependent: :destroy


  after_create :send_new_user_ticket_email, :create_root

  def send_new_user_ticket_email


    mail_data_to_rcpt = {
        url: 'http://web.wood.local/login',
        ticket_topic: self.topic,
        ticket_text: self.text,
        user_login: User.find(self.user_id).login,
        initiator_login: User.find(self.initiator_id).login,
        user_email: User.find(self.user_id).email
    }
    TicketMailer.send_new_user_ticket_to_rctp_email(mail_data_to_rcpt).deliver


    mail_data_to_sndr = {
        url: 'http://web.wood.local/login',
        ticket_topic: self.topic,
        ticket_text: self.text,
        user_login: User.find(self.user_id).login,
        initiator_login: User.find(self.initiator_id).login,
        initiator_email: User.find(self.initiator_id).email,
    }
    TicketMailer.send_new_user_ticket_to_sndr_email(mail_data_to_sndr).deliver

  end

  def create_root

    root_array = {
        ticket_type: "u",
        ticket_id: self.id,
        from_id: self.initiator_id,
        to_id: self.user_id,
        parent_id: 0
    }
    root = TicketRoot.new(root_array)
    root.save

    self.root = root.id
    self.save

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
      user_ticket = TicketToUser.find(ticket_id)
      user_ticket.completed = status
      user_ticket.save
    end
  end

  def TicketToUser.comment_new(user_id, ticket_id, inputCommText)
    if TicketToUser.is_initiator(user_id, ticket_id) or TicketToUser.is_executor(user_id, ticket_id)

      ticket = TicketToUser.find(ticket_id)

      user_comment = TicketComment.new()
      user_comment.user_id = user_id
      user_comment.ticket_to_user_id = ticket_id
      user_comment.text = inputCommText
      user_comment.root = ticket.root
      user_comment.save()

      if ticket.completed = 100
        ticket.completed = 90
        ticket.save()
      end

    end
  end


end
