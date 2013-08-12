class TicketMailer < ActionMailer::Base
  default from: "test@velskiyles.ru"

  def send_welcome_email(user)
    @user = user
    @url  = 'http://web.wood.local/login'
    mail(to: user.email, subject: "Welcome")
  end


  def send_new_group_ticket_email(ticket)




  end

  def send_new_user_ticket_email(ticket)



  end



end
