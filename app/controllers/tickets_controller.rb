class TicketsController < ApplicationController

  def index



  end

  def ticket_new
    @users = Users.all
    @groups = Groups.all
  end


  def srv_ticket_new
    var_pr = /\d/
    @ticket = TicketToUser.new()
    @ticket.initiator_id = session[:user_id]
    @ticket.users_id = params[:inputIsp].scan(var_pr)[0]
    @ticket.topic = params[:inputTopic]
    @ticket.text = params[:inputText]
    @ticket.deadline = params[:inputDateTo]
    @ticket.save

    render text: "srv_ticket_new"
  end



end
