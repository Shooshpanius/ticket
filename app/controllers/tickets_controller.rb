class TicketsController < ApplicationController

  before_filter :is_login



  def index

    @user_tickets = TicketToUser.where('user_id = ? and completed < ?', session[:user_id], 100).limit(10).sort_by{ |elem| elem.deadline }

    @group_tickets = TicketToGroup.where("group_id in (?) and completed < ?", UserByGroup.groups_for_user(session[:user_id]) , 100).limit(10).sort_by{ |elem| elem.deadline }

    my_tickets_to_users = TicketToUser.where("initiator_id = ? and completed < ?", session[:user_id], 100)
    my_tickets_to_groups = TicketToGroup.where("initiator_id = ? and completed < ?", session[:user_id], 100).limit(10)
    my_tickets = my_tickets_to_users + my_tickets_to_groups
    @my_tickets = my_tickets.sort_by{ |elem| elem.deadline }

  end

  def in
    @user_tickets = TicketToUser.where('user_id = ? and completed < ?', session[:user_id], 100).sort_by{ |elem| elem.deadline }
    @group_tickets = TicketToGroup.where("group_id in (?) and completed < ?", UserByGroup.groups_for_user(session[:user_id]) , 100).sort_by{ |elem| elem.deadline }
  end

  def out
    my_tickets_to_users = TicketToUser.where("initiator_id = ? and completed < ?", session[:user_id], 100)
    my_tickets_to_groups = TicketToGroup.where("initiator_id = ? and completed < ?", session[:user_id], 100)
    my_tickets = my_tickets_to_users + my_tickets_to_groups
    @my_tickets = my_tickets.sort_by{ |elem| elem.deadline }
  end

  def arch_in
    @user_tickets = TicketToUser.where('user_id = ? and completed = ?', session[:user_id], 100).sort_by{ |elem| elem.deadline }
    @group_tickets = TicketToGroup.where("group_id in (?) and completed = ?", UserByGroup.groups_for_user(session[:user_id]) , 100).sort_by{ |elem| elem.deadline }
  end

  def arch_out
    my_tickets_to_users = TicketToUser.where("initiator_id = ? and completed = ?", session[:user_id], 100)
    my_tickets_to_groups = TicketToGroup.where("initiator_id = ? and completed = ?", session[:user_id], 100)
    my_tickets = my_tickets_to_users + my_tickets_to_groups
    @my_tickets = my_tickets.sort_by{ |elem| elem.deadline }
  end



  def ticket_new
    @users = User.all
    @groups = Group.all
  end


  def ticket_edit

    ticket_id = params[:id].scan(/\d/)[0]

    if params[:id].scan(/u_/)[0]
      @user_ticket = TicketToUser.find(ticket_id)
      @initiator = User.find(@user_ticket.initiator_id)
      @user = User.find(@user_ticket.user_id)
      @comments = TicketToUser.find(ticket_id).ticket_comments
      render ("ticket_edit_u")
    end

    if params[:id].scan(/g_/)[0]
      @ticket = TicketToGroup.find(ticket_id)
      @initiator = User.find(@ticket.initiator_id)
      @group = Group.find(@ticket.group_id)
      @comments = TicketToGroup.find(ticket_id).ticket_comments
      render "ticket_edit_g"
    end
  end



  def srv_ticket_new

    if params[:inputIsp].scan(/u_/)[0]
      @ticket = TicketToUser.new()
      @ticket.initiator_id = session[:user_id]
      @ticket.user_id = params[:inputIsp].scan(/\d/)[0]
      @ticket.topic = params[:inputTopic]
      @ticket.text = params[:inputText]
      @ticket.completed = 0
      @ticket.deadline = params[:inputDateTo]
      @ticket.save
    end

    if params[:inputIsp].scan(/g_/)[0]
      @ticket = TicketToGroup.new()
      @ticket.initiator_id = session[:user_id]
      @ticket.group_id = params[:inputIsp].scan(/\d/)[0]
      @ticket.topic = params[:inputTopic]
      @ticket.text = params[:inputText]
      @ticket.completed = 0
      @ticket.executor = 0
      @ticket.deadline = params[:inputDateTo]
      @ticket.save
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
    TicketToGroup.change_executor(session[:user_id], params[:executor_id], params[:ticket_id])
    render text: "srv_change_executor_leader"
  end

  def srv_change_executor_member
    TicketToGroup.change_executor(session[:user_id], session[:user_id], params[:ticket_id])
    render text: "srv_change_executor_member"
  end


  private
  def is_login
    if !session[:is_login]
      redirect_to "/"
    end
  end



end
