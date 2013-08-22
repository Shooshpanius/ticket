# encoding: utf-8
class TicketComment < ActiveRecord::Base

  belongs_to :ticket_to_group
  belongs_to :ticket_to_user
  belongs_to :problem

  after_create :send_new_comment_email


  def send_new_comment_email

    if ticket_to_group != nil

      initiator = User.find(TicketToGroup.find(self.ticket_to_group).initiator_id)
      ticket = self.ticket_to_group
      group = Group.find(ticket.group_id)
      (group.leader != nil) ? leader=User.find(group.leader) : leader=nil
      (ticket.executor != 0) ? executor=User.find(ticket.executor) : executor=nil


      #send to initiator
      mail_data = {
          url: 'http://web.wood.local/login',
          type_comment: "g",
          user_status: "Инициатор",
          ticket_id: self.ticket_to_group.id,
          comment_text: self.text,
          sndr_login: User.find(self.user_id).login,
          rcpt_email: initiator.email
      }
      TicketMailer.send_new_comment_email(mail_data).deliver

      #send to leader
      if leader != nil
        mail_data = {
            url: 'http://web.wood.local/login',
            type_comment: "g",
            user_status: "Руководитель группы",
            ticket_id: self.ticket_to_group.id,
            comment_text: self.text,
            sndr_login: User.find(self.user_id).login,
            rcpt_email: leader.email
        }
        TicketMailer.send_new_comment_email(mail_data).deliver
      end

      #send to executor
      if executor != nil
        mail_data = {
            url: 'http://web.wood.local/login',
            type_comment: "g",
            user_status: "Ответственный",
            ticket_id: self.ticket_to_group.id,
            comment_text: self.text,
            sndr_login: User.find(self.user_id).login,
            rcpt_email: executor.email
        }
        TicketMailer.send_new_comment_email(mail_data).deliver
      end

      #send to actual task users
      tasks = ActualTask.where("ticket_to_group_id = ?", ticket.id)
      tasks.each do |task|
        #if task.user_id != initiator.id && task.user_id != leader.id && task.user_id != executor.id
          mail_data = {
              url: 'http://web.wood.local/login',
              type_comment: "g",
              user_status: "Участник",
              ticket_id: self.ticket_to_group.id,
              comment_text: self.text,
              sndr_login: User.find(self.user_id).login,
              rcpt_email: User.find(task.user_id).email
          }
          TicketMailer.send_new_comment_email(mail_data).deliver
        #end
      end


    end

    if ticket_to_user != nil

      mail_data = {
          url: 'http://web.wood.local/login',
          type_comment: "u",
          user_status: "Исполнитель",
          ticket_id: self.ticket_to_user.id,
          comment_text: self.text,
          sndr_login: User.find(self.user_id).login,
          rcpt_email: User.find(TicketToUser.find(self.ticket_to_user).user_id).email
      }
      TicketMailer.send_new_comment_email(mail_data).deliver

      mail_data = {
          url: 'http://web.wood.local/login',
          type_comment: "u",
          user_status: "Инициатор",
          ticket_id: self.ticket_to_user.id,
          comment_text: self.text,
          sndr_login: User.find(self.user_id).login,
          rcpt_email: User.find(TicketToUser.find(self.ticket_to_user).initiator_id).email
      }
      TicketMailer.send_new_comment_email(mail_data).deliver

    end

  end



end
