# encoding: utf-8
class TicketMailer < ActionMailer::Base
  default from: "support-mirror@velskiyles.ru"

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
    subj = "Заявка \''" + mail_data[:ticket_topic] + "\' зарегистрирована"
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


  def send_new_comment_email(mail_data)
    @mail_data = mail_data
    subj = 'Новый комментарий к заявке № ' + @mail_data[:type_comment] + '_' + @mail_data[:ticket_id].to_s
    mail(to: mail_data[:rcpt_email], subject: subj )
  end

  def send_change_executor_by_leader(mail_data)
    @mail_data = mail_data
    subj = 'Вы назначены ответственным за выполнение заявки № g_' + @mail_data[:ticket_id].to_s
    mail(to: mail_data[:rcpt_email], subject: subj )
  end

  def send_change_executor_by_member(mail_data)
    @mail_data = mail_data
    subj = 'Пользователь ' + @mail_data[:sndr_login] + ' взял ответственность за выполнение заявки № g_' + @mail_data[:ticket_id].to_s
    mail(to: mail_data[:rcpt_email], subject: subj )
  end

  def send_change_executor_to_initiator(mail_data)
    @mail_data = mail_data
    subj = 'Назначен ответственный за выполнение вашей заявки № g_' + @mail_data[:ticket_id].to_s
    mail(to: mail_data[:rcpt_email], subject: subj )
  end

  def send_change_status(mail_data)
    @mail_data = mail_data
    subj = 'Изменился % выполнения заявки № g_' + @mail_data[:ticket_id].to_s
    mail(to: mail_data[:rcpt_email], subject: subj )
  end

end
