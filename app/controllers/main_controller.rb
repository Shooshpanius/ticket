class MainController < ApplicationController

  before_filter :is_login


  def index

    @user_tickets = TicketToUser.where('users_id = ? and completed < ?', session[:user_id], 100).limit(10).sort_by{ |elem| elem.deadline }

    @group_tickets = TicketToGroup.where("groups_id in (?) and completed < ?", UserByGroup.groups_for_user(session[:user_id]) , 100).limit(10).sort_by{ |elem| elem.deadline }

    my_tickets_to_users = TicketToUser.where("initiator_id = ? and completed < ?", session[:user_id], 100)
    my_tickets_to_groups = TicketToGroup.where("initiator_id = ? and completed < ?", session[:user_id], 100).limit(10)
    my_tickets = my_tickets_to_users + my_tickets_to_groups
    @my_tickets = my_tickets.sort_by{ |elem| elem.deadline }

    render template: "tickets/index"

  end

  private
  def is_login
    if !session[:is_login]
      redirect_to "/login"
    end
  end


end
