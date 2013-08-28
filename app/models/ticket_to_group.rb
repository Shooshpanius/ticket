class TicketToGroup < ActiveRecord::Base
  belongs_to :group
  has_many :ticket_comments, dependent: :destroy

  after_create :send_new_group_ticket_email, :create_root

  def send_new_group_ticket_email

    @members = UserByGroup.users_in_group(self.group_id)
    @members.each do |member|
      mail_data_to_rcpt = {
          url: 'http://web.wood.local/login',
          ticket_topic: self.topic,
          ticket_text: self.text,
          group_name: Group.find(self.group_id).name,
          initiator_login: User.find(self.initiator_id).login,
          user_email: User.find(member.user_id).email
      }
      TicketMailer.send_new_group_ticket_to_rctp_email(mail_data_to_rcpt).deliver
    end

    mail_data_to_sndr = {
        url: 'http://web.wood.local/login',
        ticket_topic: self.topic,
        ticket_text: self.text,
        group_name: Group.find(self.group_id).name,
        initiator_login: User.find(self.initiator_id).login,
        initiator_email: User.find(self.initiator_id).email,
        members: UserByGroup.users_in_group(self.group_id)
    }
    TicketMailer.send_new_group_ticket_to_sndr_email(mail_data_to_sndr).deliver

  end


  def create_root

    root_array = {
        ticket_type: "g",
        ticket_id: self.id,
        from_id: self.initiator_id,
        to_id: self.group_id,
        parent_id: 0
    }
    root = TicketRoot.new(root_array)
    root.save

    self.root = root.id
    self.save

  end




  def TicketToGroup.is_initiator(user_id, ticket_id)
    @ticket = TicketToGroup.find(ticket_id)
    if @ticket.initiator_id == user_id
      return true
    else
      return false
    end
  end


  def TicketToGroup.is_member(user_id, ticket_id)
    @ticket = TicketToGroup.find(ticket_id)
    if UserByGroup.where("group_id = ? AND user_id = ?", @ticket.group_id, user_id).size != 0
      return true
    else
      return false
    end
  end


  def TicketToGroup.is_executor(user_id, ticket_id)
    @ticket = TicketToGroup.find(ticket_id)
    if (@ticket.executor == user_id) then
      return true
    else
      return false
    end
  end


  def TicketToGroup.is_leader(user_id, ticket_id)
    @ticket = TicketToGroup.find(ticket_id)
    @group = Group.find(@ticket.group_id)
    if (@group.leader == user_id) then
      return true
    else
      return false
    end
  end


  def TicketToGroup.change_status(user_id, status, ticket_id)
    if TicketToGroup.is_leader(user_id, ticket_id) or TicketToGroup.is_executor(user_id, ticket_id)
      user_ticket = TicketToGroup.find(ticket_id)
      user_ticket.completed = status
      user_ticket.save
      if status = 100 then
        ActualTask.where(:ticket_to_group_id => ticket_id, :user_id => user_id).delete_all
      end
    end
  end

  def TicketToGroup.change_executor(user_id, executor_id, ticket_id)
    if TicketToGroup.is_leader(user_id, ticket_id)
      user_ticket = TicketToGroup.find(ticket_id)
      user_ticket.executor = executor_id
      user_ticket.save
    else
      if TicketToGroup.is_member(user_id, ticket_id)
        user_ticket = TicketToGroup.find(ticket_id)
        user_ticket.executor = user_id
        user_ticket.save
      end
    end
  end


  def TicketToGroup.comment_new(user_id, ticket_id, inputCommText)
    if TicketToGroup.is_initiator(user_id, ticket_id) or TicketToGroup.is_member(user_id, ticket_id)

      ticket = TicketToGroup.find(ticket_id)

      user_comment = TicketComment.new()
      user_comment.user_id = user_id
      user_comment.ticket_to_group_id = ticket_id
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
