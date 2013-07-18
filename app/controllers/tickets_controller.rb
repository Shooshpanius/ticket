class TicketsController < ApplicationController

  def index

    @user_tickets = TicketToUser.where('users_id = ?', session[:user_id]).limit(10)

    u = Users.select([:id]).where("id = ?", session[:user_id])
    g = Groups.select([:id]).where("id = ?", u)
    @group_tickets = TicketToGroup.where("groups_id = ?", g)


  end

  def ticket_new
    @users = Users.all
    @groups = Groups.all
  end


  def ticket_edit

    ticket_id = params[:id].scan(/\d/)[0]

    if params[:id].scan(/u_/)[0]
      @user_ticket = TicketToUser.find(ticket_id)
      @initiator = Users.find(@user_ticket.initiator_id)
      @user = Users.find(@user_ticket.users_id)
      @comments = TicketToUser.find(ticket_id).ticket_comments
      render "ticket_edit_u"
    end

    if params[:id].scan(/g_/)[0]
      render "ticket_edit_g"
    end
  end



  def srv_ticket_new

    if params[:inputIsp].scan(/u_/)[0]
      @ticket = TicketToUser.new()
      @ticket.initiator_id = session[:user_id]
      @ticket.users_id = params[:inputIsp].scan(/\d/)[0]
      @ticket.topic = params[:inputTopic]
      @ticket.text = params[:inputText]
      @ticket.deadline = params[:inputDateTo]
      @ticket.save
    end

    if params[:inputIsp].scan(/g_/)[0]
      @ticket = TicketToGroup.new()
      @ticket.initiator_id = session[:user_id]
      @ticket.groups_id = params[:inputIsp].scan(/\d/)[0]
      @ticket.topic = params[:inputTopic]
      @ticket.text = params[:inputText]
      @ticket.deadline = params[:inputDateTo]
      @ticket.save
    end

    render text: "srv_ticket_new"
  end

  def srv_comment_u_new

    #session[:user_id]

    ticket_id = params[:ticket_id]
    user_id = session[:user_id]

    @user_ticket = TicketToUser.find(ticket_id)
    @user_ticket.ticket_comments.create({text: params[:inputCommText]})
    render text: "srv_comment_new"


  end


end
