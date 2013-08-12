class TicketMailer < ActionMailer::Base
  default from: "test@velskiyles.ru"

  def send_welcome_email(user)
    @user = user
    @url  = 'http://web.wood.local/login'
    mail(to: user.email, subject: "Welcome")
  end


  def send_new_group_ticket_email(ticket)
    @url  = 'http://web.wood.local/login'
    @ticket = ticket
    @group = Group.find(ticket.group_id)
    @initiator = User.find(ticket.initiator_id)
    @members = UserByGroup.users_in_group(ticket.group_id)
    @members.each do |member|
      @user = User.find(member.user_id)
      if @user.email.size() > 3
        @type_email = "rcpt"
        subj = "New ticket for group " + @group.name.to_s
        mail(to: @user.email, subject: subj )
      end
    end

    if @initiator.email.size() > 3
      @type_email = "sndr"
      subj = "New ticket for group " + @group.name.to_s
      mail(to: @initiator.email, subject: subj )
    end



  end

  def send_new_user_ticket_email(ticket)



  end



end
