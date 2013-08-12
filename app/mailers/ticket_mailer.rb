class TicketMailer < ActionMailer::Base
  default from: "test@velskiyles.ru"

  def send_welcome_email(user)
    @user = user
    @url  = 'http://web.wood.local/login'
    mail(to: user.email, subject: "Welcome")
  end


  def send_new_group_ticket_email(ticket)
    @ticket = ticket
    @group = Group.find(ticket.group_id)
    @initiator = User.find(ticket.initiator_id)
    @members = UserByGroup.users_in_group(ticket.group_id)
    @members.each do |member|
      @user = User.find(member.user_id)
      mail(to: @user.email, subject: "New ticket")
    end





  end

  def send_new_user_ticket_email(ticket)



  end



end
