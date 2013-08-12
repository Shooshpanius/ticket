class TicketMailer < ActionMailer::Base
  default from: "test@velskiyles.ru"

  def send_welcome_email(user)
    @user = user
    @url  = 'http://web.wood.local/login'
    mail(to: user.email, subject: "Welcome")
  end


  def send_new_group_ticket_to_rctp_email(mail_data)
    @mail_data = mail_data
    subj = "New ticket for group " + mail_data[:group_name]
    mail(to: mail_data[:user_email], subject: subj )
  end

  def send_new_group_ticket_to_sndr_email(mail_data)
    @mail_data = mail_data
    subj = "New ticket for group " + mail_data[:group_name]
    mail(to: mail_data[:initiator_email], subject: subj )
 end



end
