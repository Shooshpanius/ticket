# encoding: utf-8
class TicketsController < ApplicationController

  before_filter :is_login



  def index

    user_tickets = TicketToUser.where('user_id = ? and completed < ?', session[:user_id], 100)
    user_tickets.each do |user_ticket|
      user_ticket[:actual] = ActualTask.is_actual_u(session[:user_id], user_ticket[:id])
    end
    @user_tickets = user_tickets.sort_by{ |elem| elem.actual}.reverse.take(10)

    group_tickets = TicketToGroup.where("group_id in (?) and completed < ?", UserByGroup.groups_for_user(session[:user_id]) , 100)
    group_tickets.each do |group_ticket|
      group_ticket[:actual] = ActualTask.is_actual_g(session[:user_id], group_ticket[:id])
    end
    @group_tickets = group_tickets.sort_by{ |elem| elem.actual}.reverse.take(10)

    my_tickets_to_users = TicketToUser.where("initiator_id = ? and completed < ?", session[:user_id], 100).sort_by{ |elem| [elem.actual, elem.deadline]}.take(10)
    my_tickets_to_users.each do |user_ticket|
      user_ticket[:actual] = ActualTask.is_actual_u(session[:user_id], user_ticket[:id])
    end
    my_tickets_to_groups = TicketToGroup.where("initiator_id = ? and completed < ?", session[:user_id], 100).sort_by{ |elem| [elem.actual, elem.deadline]}.take(10)
    my_tickets_to_groups.each do |group_ticket|
      group_ticket[:actual] = ActualTask.is_actual_g(session[:user_id], group_ticket[:id])
    end
    my_tickets = my_tickets_to_users + my_tickets_to_groups
    @my_tickets = my_tickets.take(10)

  end

  def in
    user_tickets = TicketToUser.where('user_id = ? and completed < ?', session[:user_id], 100)
    user_tickets.each do |user_ticket|
      user_ticket[:actual] = ActualTask.is_actual_u(session[:user_id], user_ticket[:id])
    end
    @user_tickets = user_tickets.sort_by{ |elem| elem.actual}.reverse

    group_tickets = TicketToGroup.where("group_id in (?) and completed < ?", UserByGroup.groups_for_user(session[:user_id]) , 100)
    group_tickets.each do |group_ticket|
      group_ticket[:actual] = ActualTask.is_actual_g(session[:user_id], group_ticket[:id])
    end
    @group_tickets = group_tickets.sort_by{ |elem| elem.actual}.reverse


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
    @my_tickets = my_tickets.take(10)
  end

  def arch_in
    user_tickets = TicketToUser.where('user_id = ? and completed = ?', session[:user_id], 100).sort_by{ |elem| [elem.actual, elem.deadline]}
    user_tickets.each do |user_ticket|
      user_ticket[:actual] = ActualTask.is_actual_u(session[:user_id], user_ticket[:id])
    end
    @user_tickets = user_tickets.take(10)

    group_tickets = TicketToGroup.where("group_id in (?) and completed = ?", UserByGroup.groups_for_user(session[:user_id]) , 100).sort_by{ |elem| [elem.actual, elem.deadline]}
    group_tickets.each do |group_ticket|
      group_ticket[:actual] = ActualTask.is_actual_g(session[:user_id], group_ticket[:id])
    end
    @group_tickets = group_tickets.take(10)
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
    @my_tickets = my_tickets.take(10)
  end



  def ticket_new
    @users = User.all
    @groups = Group.all
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
        @comments = TicketToUser.find(ticket_id).ticket_comments
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
          @comments = TicketToGroup.find(ticket_id).ticket_comments
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
    TicketToGroup.change_status(session[:user_id], params[:status], params[:ticket_id])
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

    TicketToGroup.change_executor(session[:user_id], params[:executor_id], params[:ticket_id])
    render text: "srv_change_executor_leader"
  end

  def srv_change_executor_member
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
