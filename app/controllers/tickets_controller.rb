class TicketsController < ApplicationController

  def index
  end

  def ticket_new
    @users = Users.all
    @groups = Groups.all
  end

end
