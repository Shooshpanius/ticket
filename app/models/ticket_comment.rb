class TicketComment < ActiveRecord::Base

  belongs_to :ticket_to_group
  belongs_to :ticket_to_user
  belongs_to :problem

  after_create :send_new_comment_email


  def send_new_comment_email
    if ticket_to_group != nil
      users = UserByGroup.users_in_group(self.ticket_to_group)
      users.each do |user|
        mail_data = {
            url: 'http://web.wood.local/login',
            type_comment: "g",
            ticket_id: self.ticket_to_group,
            comment_text: self.text,
            sndr_login: User.find(self.user_id).login,
            rcpt_email: User.find(user.id).email
        }
        TicketMailer.send_new_comment_email(mail_data).deliver
      end
    end



    if ticket_to_user != nil

      mail_data = {
          url: 'http://web.wood.local/login',
          type_comment: "g",
          ticket_id: self.ticket_to_user.id,
          comment_text: self.text,
          sndr_login: User.find(self.user_id).login,
          rcpt_email: User.find(TicketToUser.find(self.ticket_to_user).user_id).email
      }
      TicketMailer.send_new_comment_email(mail_data).deliver


      mail_data = {
          url: 'http://web.wood.local/login',
          type_comment: "g",
          ticket_id: self.ticket_to_user.id,
          comment_text: self.text,
          sndr_login: User.find(self.user_id).login,
          rcpt_email: User.find(TicketToUser.find(self.ticket_to_user).initiator_id).email
      }
      TicketMailer.send_new_comment_email(mail_data).deliver


    end


    #mail_data_to_rcpt = {
    #    url: 'http://web.wood.local/login',
    #    ticket_topic: self.topic,
    #    ticket_text: self.text,
    #    user_login: User.find(self.user_id).login,
    #    initiator_login: User.find(self.initiator_id).login,
    #    user_email: User.find(self.user_id).email
    #}
    #TicketMailer.send_new_user_ticket_to_rctp_email(mail_data_to_rcpt).deliver
    #
    #
    #mail_data_to_sndr = {
    #    url: 'http://web.wood.local/login',
    #    ticket_topic: self.topic,
    #    ticket_text: self.text,
    #    user_login: User.find(self.user_id).login,
    #    initiator_login: User.find(self.initiator_id).login,
    #    initiator_email: User.find(self.initiator_id).email,
    #}
    #TicketMailer.send_new_user_ticket_to_sndr_email(mail_data_to_sndr).deliver

  end



end
