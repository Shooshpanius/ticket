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
      header = (self.text.split("<br>").first[0...100].gsub("<div>", "")  || "Новый комментарий")
      created_at = self.created_at.strftime("%Y-%m-%d %H:%M:%S")
      sndr = User.find(self.user_id)
      sndr_login = sndr.login
      sndr_fio = (sndr.f_name || "") + " " + (sndr.i_name || "") + " " + (sndr.o_name || "")

      if group.leader != nil
        leader=User.find(group.leader)
        leader_id = leader.id
      else
        leader=nil
        leader_id = nil
      end

      if ticket.executor != 0
        executor=User.find(ticket.executor)
        executor_id = executor.id
      else
        executor=nil
        executor_id = nil
      end



      #send to initiator
      mail_data = {
          url: 'http://web.wood.local/login',
          type_comment: "g",
          user_status: "Инициатор",
          ticket_id: self.ticket_to_group.id,
          comment_text: self.text,
          sndr_login: sndr_login,
          rcpt_email: initiator.email,
          header: header,
          created_at: created_at,
          sndr_fio: sndr_fio,
          rcpt_processing: initiator.processing
      }

      TicketMailer.send_new_comment_email(mail_data).deliver

      #send to leader
      if leader != nil
        if leader_id != initiator.id
          mail_data = {
              url: 'http://web.wood.local/login',
              type_comment: "g",
              user_status: "Руководитель группы",
              ticket_id: self.ticket_to_group.id,
              comment_text: self.text,
              sndr_login: sndr_login,
              rcpt_email: leader.email,
              header: header,
              created_at: created_at,
              sndr_fio: sndr_fio,
              rcpt_processing: leader.processing
          }

          TicketMailer.send_new_comment_email(mail_data).deliver
        end
      end

      #send to executor
      if executor != nil
        if executor_id != initiator.id && executor_id != leader_id
            mail_data = {
              url: 'http://web.wood.local/login',
              type_comment: "g",
              user_status: "Ответственный",
              ticket_id: self.ticket_to_group.id,
              comment_text: self.text,
              sndr_login: sndr_login,
              rcpt_email: executor.email,
              header: header,
              created_at: created_at,
              sndr_fio: sndr_fio,
              rcpt_processing: executor.processing
          }

          TicketMailer.send_new_comment_email(mail_data).deliver
        end
      end

      #send to actual task users
      tasks = ActualTask.where("ticket_to_group_id = ?", ticket.id)
      tasks.each do |task|
        if task.user_id != initiator.id && task.user_id != leader_id && task.user_id != executor_id
          mail_data = {
              url: 'http://web.wood.local/login',
              type_comment: "g",
              user_status: "Участник",
              ticket_id: self.ticket_to_group.id,
              comment_text: self.text,
              sndr_login: sndr_login,
              rcpt_email: User.find(task.user_id).email,
              header: header,
              created_at: created_at,
              sndr_fio: sndr_fio,
              rcpt_processing: User.find(task.user_id).processing
          }

          TicketMailer.send_new_comment_email(mail_data).deliver
        end
      end


    end

    if ticket_to_user != nil

      mail_data = {
          url: 'http://web.wood.local/login',
          type_comment: "u",
          user_status: "Исполнитель",
          ticket_id: self.ticket_to_user.id,
          comment_text: self.text,
          sndr_login: sndr_login,
          rcpt_email: User.find(TicketToUser.find(self.ticket_to_user).user_id).email,
          header: header,
          created_at: created_at,
          sndr_fio: sndr_fio,
          rcpt_processing: User.find(TicketToUser.find(self.ticket_to_user).user_id).processing
      }

      TicketMailer.send_new_comment_email(mail_data).deliver

      mail_data = {
          url: 'http://web.wood.local/login',
          type_comment: "u",
          user_status: "Инициатор",
          ticket_id: self.ticket_to_user.id,
          comment_text: self.text,
          sndr_login: sndr_login,
          rcpt_email: User.find(TicketToUser.find(self.ticket_to_user).initiator_id).email,
          header: header,
          created_at: created_at,
          sndr_fio: sndr_fio,
          rcpt_processing: User.find(TicketToUser.find(self.ticket_to_user).initiator_id).processing
      }

      TicketMailer.send_new_comment_email(mail_data).deliver

    end

  end



end
