class MainController < ApplicationController

  before_filter :is_login


  def index

    @user_tickets = TicketToUser.where('users_id = ?', session[:user_id]).limit(10).sort_by{ |elem| elem.deadline }

    u = Users.select([:id]).where("id = ?", session[:user_id])
    g = Groups.select([:id]).where("id = ?", u)
    @group_tickets = TicketToGroup.where("groups_id = ?", g).limit(10).sort_by{ |elem| elem.deadline }

    my_tickets_to_users = TicketToUser.where("initiator_id = ?", session[:user_id]).limit(10)
    my_tickets_to_groups = TicketToGroup.where("initiator_id = ?", session[:user_id]).limit(10)
    my_tickets = my_tickets_to_users + my_tickets_to_groups
    @my_tickets = my_tickets.sort_by{ |elem| elem.deadline }

    render template: "tickets/index"

  end

  private
  def is_login
    if !session[:is_login]
      redirect_to "/"
    end
  end


end
