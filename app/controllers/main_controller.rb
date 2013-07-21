class MainController < ApplicationController

  before_filter :is_login


  def index

    @user_tickets = TicketToUser.where('users_id = ?', session[:user_id]).limit(10)

    u = Users.select([:id]).where("id = ?", session[:user_id])
    g = Groups.select([:id]).where("id = ?", u)
    @group_tickets = TicketToGroup.where("groups_id = ?", g)

    render template: "tickets/index"

  end

  private
  def is_login
    if !session[:is_login]
      redirect_to "/"
    end
  end


end
