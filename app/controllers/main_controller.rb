class MainController < ApplicationController

  before_filter :is_login



  def index

    user_tickets = TicketToUser.where('user_id = ? and completed < ?', session[:user_id], 100).sort_by{ |elem| [elem.actual, elem.deadline]}
    user_tickets.each do |user_ticket|
      user_ticket[:actual] = ActualTask.is_actual_u(session[:user_id], user_ticket[:id])
    end
    @user_tickets = user_tickets.take(10)



    group_tickets = TicketToGroup.where("group_id in (?) and completed < ?", UserByGroup.groups_for_user(session[:user_id]) , 100).sort_by{ |elem| [elem.actual, elem.deadline]}
    group_tickets.each do |group_ticket|
      group_ticket[:actual] = ActualTask.is_actual_g(session[:user_id], group_ticket[:id])
    end
    @group_tickets = group_tickets.take(10)



    my_tickets_to_users = TicketToUser.where("initiator_id = ? and completed < ?", session[:user_id], 100).sort_by{ |elem| [elem.actual, elem.deadline]}.take(10)
    my_tickets_to_users.each do |user_ticket|
      user_ticket[:actual] = ActualTask.is_actual_u(session[:user_id], user_ticket[:id])
    end

    my_tickets_to_groups = TicketToGroup.where("initiator_id = ? and completed < ?", session[:user_id], 100).sort_by{ |elem| [elem.actual, elem.deadline]}.take(10)
    my_tickets_to_groups.each do |group_ticket|
      group_ticket[:actual] = ActualTask.is_actual_g(session[:user_id], group_ticket[:id])
    end

    my_tickets = my_tickets_to_users + my_tickets_to_groups
    @my_tickets = my_tickets.take(10)


    render template: "tickets/index"

  end

  private
  def is_login
    if !session[:is_login]
      redirect_to "/login"
    end
  end


end
