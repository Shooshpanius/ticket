class MainController < ApplicationController

  before_filter :is_login



  def index

    @user_tickets = TicketToUser.where('user_id = ? and completed < ?', session[:user_id], 100).limit(10).sort_by{ |elem| elem.deadline }


    @group_tickets = TicketToGroup.where("group_id in (?) and completed < ?", UserByGroup.groups_for_user(session[:user_id]) , 100).limit(10).sort_by{ |elem| elem.deadline }


    #@group_tickets.add_column("q")

    @group_tickets1 = @group_tickets.sort_by{ |elem| elem.group_id }

    #@group_tickets.each_with_index do |(user_tickets), i|
    #  @group_tickets1[i] = {
    #      qqq: 111
    #
    #
    #  }
    #  #user_tickets[:q] = 1
    ##@group_tickets.add_column("active")
    #end


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
