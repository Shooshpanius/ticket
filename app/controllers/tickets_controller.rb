# encoding: utf-8
class TicketsController < ApplicationController

  before_filter :is_login



  def index

    #user_tickets = TicketToUser.where('user_id = ? and completed < ?', session[:user_id], 100)
    #user_tickets.each do |user_ticket|
    #  user_ticket[:actual] = ActualTask.is_actual_u(session[:user_id], user_ticket[:id])
    #end
    #@user_tickets = user_tickets.sort_by{ |elem| elem.actual}.reverse.take(10)
    #
    #group_tickets = TicketToGroup.where("group_id in (?) and completed < ?", UserByGroup.groups_for_user(session[:user_id]) , 100)
    #group_tickets.each do |group_ticket|
    #  group_ticket[:actual] = ActualTask.is_actual_g(session[:user_id], group_ticket[:id])
    #end
    #@group_tickets = group_tickets.sort_by{ |elem| elem.actual}.reverse.take(10)
    #
    #my_tickets_to_users = TicketToUser.where("initiator_id = ? and completed < ?", session[:user_id], 100).sort_by{ |elem| [elem.actual, elem.deadline]}.take(10)
    #my_tickets_to_users.each do |user_ticket|
    #  user_ticket[:actual] = ActualTask.is_actual_u(session[:user_id], user_ticket[:id])
    #end
    #my_tickets_to_groups = TicketToGroup.where("initiator_id = ? and completed < ?", session[:user_id], 100).sort_by{ |elem| [elem.actual, elem.deadline]}.take(10)
    #my_tickets_to_groups.each do |group_ticket|
    #  group_ticket[:actual] = ActualTask.is_actual_g(session[:user_id], group_ticket[:id])
    #end
    #my_tickets = my_tickets_to_users + my_tickets_to_groups
    #@my_tickets = my_tickets.take(10)


    z_pers_normal = TicketToUser.where("user_id = ? and completed < ? and deadline > ?", session[:user_id], 100, Date.today.next.next.next)
    (z_pers_normal!=nil) ? z_pers_normal_array=z_pers_normal.count : z_pers_normal_array=0
    z_pers_warn = TicketToUser.where("user_id = ? and completed < ? and deadline > ? and deadline <= ?", session[:user_id], 100, Date.today, Date.today.next.next.next)
    (z_pers_warn!=nil) ? z_pers_warn_array=z_pers_warn.count : z_pers_warn_array=0
    z_pers_red = TicketToUser.where("user_id = ? and completed < ? and deadline <= ?", session[:user_id], 100, Date.today)
    (z_pers_red!=nil) ? z_pers_red_array=z_pers_red.count : z_pers_red_array=0

    z_group_pers_normal = TicketToGroup.where("executor = ? and completed < ? and deadline > ?", session[:user_id], 100, Date.today.next.next.next)
    (z_group_pers_normal!=nil) ? z_group_pers_normal_array=z_group_pers_normal.count : z_group_pers_normal_array=0
    z_group_pers_warn = TicketToGroup.where("executor = ? and completed < ? and deadline > ? and deadline <= ?", session[:user_id], 100, Date.today, Date.today.next.next.next)
    (z_group_pers_warn!=nil) ? z_group_pers_warn_array=z_group_pers_warn.count : z_group_pers_warn_array=0
    z_group_pers_red = TicketToGroup.where("executor = ? and completed < ? and deadline <= ?", session[:user_id], 100, Date.today)
    (z_group_pers_red!=nil) ? z_group_pers_red_array=z_group_pers_red.count : z_group_pers_red_array=0



    @form_data = {
        z_pers_normal: z_pers_normal_array,
        z_pers_warn: z_pers_warn_array,
        z_pers_red: z_pers_red_array,

        z_group_pers_normal: z_group_pers_normal_array,
        z_group_pers_warn: z_group_pers_warn_array,
        z_group_pers_red: z_group_pers_red_array,

        z_group_other_normal: 0,
        z_group_other_warn: 0,
        z_group_other_red: 0,

        z_out_normal: 0,
        z_out_warn: 0,
        z_out_red: 0
    }

  end

  def in
    user_tickets = TicketToUser.where('user_id = ? and completed < ?', session[:user_id], 100)
    user_tickets.each do |user_ticket|
      user_ticket[:actual] = ActualTask.is_actual_u(session[:user_id], user_ticket[:id])
    end
    user_tickets.sort! do |a, b|
      (b.actual <=> a.actual).nonzero? ||
          (b.created_at <=> a.created_at)
    end

    group_tickets = TicketToGroup.where("group_id in (?) and completed < ?", UserByGroup.groups_for_user(session[:user_id]) , 100)
    group_tickets.each do |group_ticket|
      group_ticket[:actual] = ActualTask.is_actual_g(session[:user_id], group_ticket[:id])
    end
    group_tickets.sort! do |a, b|
      (b.actual <=> a.actual).nonzero? ||
          (b.created_at <=> a.created_at)
    end

    @form_data = {
        user_tickets: user_tickets,
        group_tickets: group_tickets
    }
  end

  def out
    my_tickets_to_users = TicketToUser.where("initiator_id = ? and completed < ?", session[:user_id], 100).sort_by{ |elem| [elem.actual, elem.deadline]}.take(10)
    my_tickets_to_users.each do |user_ticket|
      user_ticket[:actual] = ActualTask.is_actual_u(session[:user_id], user_ticket[:id])
    end
    my_tickets_to_groups = TicketToGroup.where("initiator_id = ? and completed < ?", session[:user_id], 100).sort_by{ |elem| [elem.actual, elem.deadline]}.take(10)
    my_tickets_to_groups.each do |group_ticket|
      group_ticket[:actual] = ActualTask.is_actual_g(session[:user_id], group_ticket[:id])
    end
    my_tickets = my_tickets_to_users + my_tickets_to_groups
    @my_tickets = my_tickets
  end

  def arch_in
    user_tickets = TicketToUser.where('user_id = ? and completed = ?', session[:user_id], 100)
    user_tickets.each do |user_ticket|
      user_ticket[:actual] = ActualTask.is_actual_u(session[:user_id], user_ticket[:id])
    end
    user_tickets.sort! do |a, b|
      (b.actual <=> a.actual).nonzero? ||
          (b.created_at <=> a.created_at)
    end

    group_tickets = TicketToGroup.where("group_id in (?) and completed = ?", UserByGroup.groups_for_user(session[:user_id]) , 100)
    group_tickets.each do |group_ticket|
      group_ticket[:actual] = ActualTask.is_actual_g(session[:user_id], group_ticket[:id])
    end
    group_tickets.sort! do |a, b|
      (b.actual <=> a.actual).nonzero? ||
          (b.created_at <=> a.created_at)
    end

    @form_data = {
        user_tickets: user_tickets,
        group_tickets: group_tickets
    }
  end

  def arch_out
    my_tickets_to_users = TicketToUser.where("initiator_id = ? and completed = ?", session[:user_id], 100).sort_by{ |elem| [elem.actual, elem.deadline]}.take(10)
    my_tickets_to_users.each do |user_ticket|
      user_ticket[:actual] = ActualTask.is_actual_u(session[:user_id], user_ticket[:id])
    end
    my_tickets_to_groups = TicketToGroup.where("initiator_id = ? and completed = ?", session[:user_id], 100).sort_by{ |elem| [elem.actual, elem.deadline]}.take(10)
    my_tickets_to_groups.each do |group_ticket|
      group_ticket[:actual] = ActualTask.is_actual_g(session[:user_id], group_ticket[:id])
    end
    my_tickets = my_tickets_to_users + my_tickets_to_groups
    @my_tickets = my_tickets
  end



  def ticket_new

    if params[:id] == nil
      @users = User.all
      @groups = Group.all
      @form_data = {
        main_ticket: nil,
        main_ticket_type: params
      }
    else

      ticket_id = params[:id].scan(/\d/).join.to_i

      if params[:id].scan(/u_/)[0]
        if TicketToUser.is_initiator(session[:user_id], ticket_id)==false && TicketToUser.is_executor(session[:user_id], ticket_id)==false
        then
          redirect_to "/"
        else
          @users = User.all
          @groups = Group.all
          @form_data = {
            main_ticket: TicketToUser.find(ticket_id),
            main_ticket_type: "u"
          }
        end
      end

      if params[:id].scan(/g_/)[0]
        if TicketToGroup.is_initiator(session[:user_id], ticket_id)==true || TicketToGroup.is_executor(session[:user_id], ticket_id)==true ||
            TicketToGroup.is_member(session[:user_id], ticket_id)==true || TicketToGroup.is_leader(session[:user_id], ticket_id)==true
        then
          @users = User.all
          @groups = Group.all
          @form_data = {
            main_ticket: TicketToGroup.find(ticket_id),
            main_ticket_type: "g"
          }

        else
          redirect_to "/"
        end
      end

    end

  end


  def ticket_edit

    ticket_id = params[:id].scan(/\d/).join.to_i

    if params[:id].scan(/u_/)[0]
      if TicketToUser.is_initiator(session[:user_id], ticket_id)==false && TicketToUser.is_executor(session[:user_id], ticket_id)==false
      then
        redirect_to "/"
      else
        @user_ticket = TicketToUser.find(ticket_id)
        @initiator = User.find(@user_ticket.initiator_id)
        @user = User.find(@user_ticket.user_id)
        @comments = TicketToUser.find(ticket_id).ticket_comments.sort_by{ |elem| elem.created_at}.reverse
        render ("ticket_edit_u")
      end
    end

    if params[:id].scan(/g_/)[0]
      if TicketToGroup.is_initiator(session[:user_id], ticket_id)==true || TicketToGroup.is_executor(session[:user_id], ticket_id)==true ||
          TicketToGroup.is_member(session[:user_id], ticket_id)==true || TicketToGroup.is_leader(session[:user_id], ticket_id)==true
        then
          @ticket = TicketToGroup.find(ticket_id)
          @initiator = User.find(@ticket.initiator_id)
          @group = Group.find(@ticket.group_id)
          @comments = TicketToGroup.find(ticket_id).ticket_comments.sort_by{ |elem| elem.created_at}.reverse
          render "ticket_edit_g"
        else
          redirect_to "/"
        end
    end
  end



  def srv_ticket_new

    if params[:inputIsp].scan(/u_/)[0]
      ticket = TicketToUser.new()
      ticket.initiator_id = session[:user_id]
      ticket.user_id = params[:inputIsp].scan(/\d/)[0]
      ticket.topic = params[:inputTopic]
      ticket.text = params[:inputText]
      ticket.completed = 0
      ticket.deadline = params[:inputDateTo]
      ticket.save

      if params[:inputParentId] != nil
        if params[:inputParentType] = "g"
          parent_data = {
            parent_user_ticket_id: 0,
            parent_group_ticket_id: params[:inputParentId],
            children_user_ticket_id: ticket.id,
            children_group_ticket_id: 0
          }
          children = TicketChildren.new(parent_data)
          children.save
        else
          parent_data = {
            parent_user_ticket_id: params[:inputParentId],
            parent_group_ticket_id: 0,
            children_user_ticket_id: ticket.id,
            children_group_ticket_id: 0
          }
          children = TicketChildren.new(parent_data)
          children.save
        end
      end

    end

    if params[:inputIsp].scan(/g_/)[0]
      ticket = TicketToGroup.new()
      ticket.initiator_id = session[:user_id]
      ticket.group_id = params[:inputIsp].scan(/\d/)[0]
      ticket.topic = params[:inputTopic]
      ticket.text = params[:inputText]
      ticket.completed = 0
      ticket.executor = 0
      ticket.deadline = params[:inputDateTo]
      ticket.save

      if params[:inputParentId] != nil
        if params[:inputParentType] = "g"
          parent_data = {
              parent_user_ticket_id: 0,
              parent_group_ticket_id: params[:inputParentId],
              children_user_ticket_id: 0,
              children_group_ticket_id: ticket.id
          }
          children = TicketChildren.new(parent_data)
          children.save
        else
          parent_data = {
              parent_user_ticket_id: params[:inputParentId],
              parent_group_ticket_id: 0,
              children_user_ticket_id: 0,
              children_group_ticket_id: ticket.id
          }
          children = TicketChildren.new(parent_data)
          children.save
        end
      end

    end

    render text: "srv_ticket_new"
  end

  def srv_comment_u_new
    TicketToUser.comment_new(session[:user_id], params[:ticket_id], params[:inputCommText])
    render text: "srv_comment_new"
  end

  def srv_comment_g_new
    TicketToGroup.comment_new(session[:user_id], params[:ticket_id], params[:inputCommText])
    render text: "srv_comment_new"
  end


  def srv_change_u_status
    TicketToUser.change_status(session[:user_id], params[:status], params[:ticket_id])
    render text: "srv_change_u_status"
  end

  def srv_change_g_status

    ticket = TicketToGroup.find(params[:ticket_id].to_i)
    group = Group.find(ticket.group_id)
    (group.leader != nil) ? leader=User.find(group.leader) : leader=nil

    mail_data = {
        url: 'http://web.wood.local/login',
        type_comment: "g",
        ticket_id: params[:ticket_id],
        comment_topic: ticket.topic,
        comment_text: ticket.text,
        completed: params[:status],
        sndr_login: User.find(session[:user_id]).login,
        rcpt_email: User.find(ticket.initiator_id).email
    }
    TicketMailer.send_change_status(mail_data).deliver

    if group.leader != nil
      mail_data = {
          url: 'http://web.wood.local/login',
          type_comment: "g",
          ticket_id: params[:ticket_id],
          comment_topic: ticket.topic,
          comment_text: ticket.text,
          completed: params[:status],
          sndr_login: User.find(session[:user_id]).login,
          rcpt_email: leader.email
      }
      TicketMailer.send_change_status(mail_data).deliver
    end

    TicketToGroup.change_status(session[:user_id], params[:status], params[:ticket_id])
    render text: "srv_change_g_status"
  end

  def srv_change_g_status_100

    if (params[:comm] || '').strip != ""

      ticket = TicketToGroup.find(params[:ticket_id].to_i)
      group = Group.find(ticket.group_id)
      (group.leader != nil) ? leader=User.find(group.leader) : leader=nil

      mail_data = {
          url: 'http://web.wood.local/login',
          type_comment: "g",
          ticket_id: params[:ticket_id],
          comment_topic: ticket.topic,
          comment_text: ticket.text,
          completed: 100,
          sndr_login: User.find(session[:user_id]).login,
          rcpt_email: User.find(ticket.initiator_id).email
      }
      TicketMailer.send_change_status(mail_data).deliver

      if group.leader != nil
        mail_data = {
            url: 'http://web.wood.local/login',
            type_comment: "g",
            ticket_id: params[:ticket_id],
            comment_topic: ticket.topic,
            comment_text: ticket.text,
            completed: 100,
            sndr_login: User.find(session[:user_id]).login,
            rcpt_email: leader.email
        }
        TicketMailer.send_change_status(mail_data).deliver
      end

      TicketToGroup.change_status(session[:user_id], 100, params[:ticket_id])

      comm = "Заявка закрыта пользователем " + User.find(session[:user_id]).login + " с комментарием: <br /><br />" + params[:comm]
      TicketToGroup.comment_new(session[:user_id], params[:ticket_id], comm)

    end
    render text: "srv_change_g_status"
  end



  def srv_change_executor_leader

    ticket = TicketToGroup.find(params[:ticket_id].to_i)
    group = Group.find(ticket.group_id)
    mail_data = {
        url: 'http://web.wood.local/login',
        type_comment: "g",
        ticket_id: params[:ticket_id],
        comment_topic: ticket.topic,
        comment_text: ticket.text,
        sndr_login: User.find(group.leader).login,
        rcpt_email: User.find(params[:executor_id]).email
    }
    TicketMailer.send_change_executor_by_leader(mail_data).deliver

    mail_data = {
        url: 'http://web.wood.local/login',
        type_comment: "g",
        ticket_id: params[:ticket_id],
        comment_topic: ticket.topic,
        comment_text: ticket.text,
        sndr_login: User.find(group.leader).login,
        rcpt_email: User.find(ticket.initiator_id).email,
        exec_login: User.find(params[:executor_id]).login
    }
    TicketMailer.send_change_executor_to_initiator(mail_data).deliver

    TicketToGroup.change_executor(session[:user_id], params[:executor_id], params[:ticket_id])
    render text: "srv_change_executor_leader"
  end

  def srv_change_executor_member

    ticket = TicketToGroup.find(params[:ticket_id].to_i)
    group = Group.find(ticket.group_id)
    (group.leader != nil) ? leader=User.find(group.leader) : leader=nil

    if group.leader != nil
      mail_data = {
          url: 'http://web.wood.local/login',
          type_comment: "g",
          ticket_id: params[:ticket_id],
          comment_topic: ticket.topic,
          comment_text: ticket.text,
          sndr_login: User.find(session[:user_id]).login,
          rcpt_email: leader.email
      }
      TicketMailer.send_change_executor_by_member(mail_data).deliver
    end

    mail_data = {
        url: 'http://web.wood.local/login',
        type_comment: "g",
        ticket_id: params[:ticket_id],
        comment_topic: ticket.topic,
        comment_text: ticket.text,
        sndr_login: User.find(session[:user_id]).login,
        rcpt_email: User.find(ticket.initiator_id).email,
        exec_login: User.find(session[:user_id]).login
    }
    TicketMailer.send_change_executor_to_initiator(mail_data).deliver

    TicketToGroup.change_executor(session[:user_id], session[:user_id], params[:ticket_id])
    render text: "srv_change_executor_member"
  end


  def srv_change_g_actual
    response = ActualTask.change_g_active(session[:user_id], params[:status], params[:ticket_id])
    render text: response
  end

  def srv_change_u_actual
    response = ActualTask.change_u_active(session[:user_id], params[:status], params[:ticket_id])
    render text: response
  end

  def srv_get_group_list

    @form_data = {
        users_in_group: [],
        ticket_id: params[:ticket_id]
    }

    is_user_in_group = UserByGroup.is_user_in_group(session[:user_id], params[:group_id]).size

    @form_data[:users_in_group] = UserByGroup.users_in_group(params[:group_id]) if is_user_in_group.size != 0

    render(:layout => false)

  end

  def download
    send_file "public/attache/#{params[:file_name]}", :type=>MIME::Types.type_for("public/attache/#{params[:file_name]}").first.content_type
    #send_file "#{Rails.root}/public/attache/#{params[:file_name]}", :type=>"application/zip"
  end

  private
  def is_login
    if !session[:is_login]
      redirect_to "/"
    end
  end



end
