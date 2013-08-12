# encoding: utf-8
class TicketMailer < ActionMailer::Base
  default from: "test@velskiyles.ru"

  require "magic_encoding"

  def send_welcome_email(user)
    @user = user
    @url  = 'http://web.wood.local/login'
    mail(to: user.email, subject: "Welcome")
  end


  def send_new_group_ticket_to_rctp_email(mail_data)
    @mail_data = mail_data
    subj = "Новая заявка на группу " + mail_data[:group_name]
    mail(to: mail_data[:user_email], subject: subj )
  end

  def send_new_group_ticket_to_sndr_email(mail_data)
    @mail_data = mail_data
    subj = "Ваша заявка на группу " + mail_data[:group_name] + " зарегистрирована"
    mail(to: mail_data[:initiator_email], subject: subj )
  end

  def send_new_user_ticket_to_rctp_email(mail_data)
    @mail_data = mail_data
    subj = "Новая заявка к исполнению от " + mail_data[:initiator_login]
    mail(to: mail_data[:user_email], subject: subj )
  end

  def send_new_user_ticket_to_sndr_email(mail_data)
    @mail_data = mail_data
    subj = 'Ваша заявка пользователю ' + mail_data[:user_login] + " зарегистрирована"
    mail(to: mail_data[:initiator_email], subject: subj )
  end



end
