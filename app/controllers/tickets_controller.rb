class TicketsController < ApplicationController

  def index



  end

  def ticket_new
    @users = Users.all
    @groups = Groups.all
  end


  def srv_ticket_new

    @ticket = Ticket.new()
    @ticket.initiator_id = session[:user_id]
    @ticket.executor_id = params[:inputIsp]
    @ticket.executor_type = 0
    @ticket.topic = params[:inputTopic]
    @ticket.text = params[:inputText]
    @ticket.deadline = params[:inputDateTo]
    @ticket.save

    render text: "srv_ticket_new"
  end



end
