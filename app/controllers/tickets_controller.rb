class TicketsController < ApplicationController

  def index
  end

  def ticket_new
    @users = Users.all
    @groups = Groups.all
  end


  def srv_ticket_new

    render text: "srv_ticket_new"
  end


end
