class TicketsController < ApplicationController

  def index



  end

  def ticket_new
    @users = Users.all
    @groups = Groups.all
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



end
