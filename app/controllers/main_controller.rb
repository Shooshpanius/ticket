class MainController < ApplicationController

  before_filter :is_login



  def index

    #user_tickets = TicketToUser.where('user_id = ? and completed < ?', session[:user_id], 100)
    #user_tickets.each do |user_ticket|
    #  user_ticket[:actual] = ActualTask.is_actual_u(session[:user_id], user_ticket[:id])
    #end
    #@user_tickets = user_tickets.sort_by{ |elem| elem.actual}.reverse.take(10)
    #
    #group_tickets = TicketToGroup.where("group_id in (?) and completed < ?", UserByGroup.groups_for_user(session[:user_id]) , 100)
    #group_tickets.each do |group_ticket|
    #  group_ticket[:actual] = ActualTask.is_actual_g(session[:user_id], group_ticket[:id])
    #end
    #@group_tickets = group_tickets.sort_by{ |elem| elem.actual}.reverse.take(10)
    #
    #my_tickets_to_users = TicketToUser.where("initiator_id = ? and completed < ?", session[:user_id], 100).sort_by{ |elem| [elem.actual, elem.deadline]}.take(10)
    #my_tickets_to_users.each do |user_ticket|
    #  user_ticket[:actual] = ActualTask.is_actual_u(session[:user_id], user_ticket[:id])
    #end
    #my_tickets_to_groups = TicketToGroup.where("initiator_id = ? and completed < ?", session[:user_id], 100).sort_by{ |elem| [elem.actual, elem.deadline]}.take(10)
    #my_tickets_to_groups.each do |group_ticket|
    #  group_ticket[:actual] = ActualTask.is_actual_g(session[:user_id], group_ticket[:id])
    #end
    #my_tickets = my_tickets_to_users + my_tickets_to_groups
    #@my_tickets = my_tickets.take(10)

    #TicketToUser.where("user_id = ? and completed < ? and deadline > ?", session[:user_id], 100, now.date.next.next.next)

    z_pers_normal = TicketToUser.where("user_id = ? and completed < ? and deadline > ?", session[:user_id], 100, Date.today.next.next.next)
    (z_pers_normal!=nil) ? z_pers_normal_array=z_pers_normal.count : z_pers_normal_array=0
    z_pers_warn = TicketToUser.where("user_id = ? and completed < ? and deadline > ? and deadline <= ?", session[:user_id], 100, Date.today, Date.today.next.next.next)
    (z_pers_warn!=nil) ? z_pers_warn_array=z_pers_warn.count : z_pers_warn_array=0
    z_pers_red = TicketToUser.where("user_id = ? and completed < ? and deadline <= ?", session[:user_id], 100, Date.today)
    (z_pers_red!=nil) ? z_pers_red_array=z_pers_red.count : z_pers_red_array=0

    z_group_pers_normal = TicketToGroup.where("executor = ? and completed < ? and deadline > ?", session[:user_id], 100, Date.today.next.next.next)
    (z_group_pers_normal!=nil) ? z_group_pers_normal_array=z_group_pers_normal.count : z_group_pers_normal_array=0
    z_group_pers_warn = TicketToGroup.where("executor = ? and completed < ? and deadline > ? and deadline <= ?", session[:user_id], 100, Date.today, Date.today.next.next.next)
    (z_group_pers_warn!=nil) ? z_group_pers_warn_array=z_group_pers_warn.count : z_group_pers_warn_array=0
    z_group_pers_red = TicketToGroup.where("executor = ? and completed < ? and deadline <= ?", session[:user_id], 100, Date.today)
    (z_group_pers_red!=nil) ? z_group_pers_red_array=z_group_pers_red.count : z_group_pers_red_array=0



    @form_data = {
        z_pers_normal: z_pers_normal_array,
        z_pers_warn: z_pers_warn_array,
        z_pers_red: z_pers_red_array,

        z_group_pers_normal: z_group_pers_normal_array,
        z_group_pers_warn: z_group_pers_warn_array,
        z_group_pers_red: z_group_pers_red_array,

        z_group_other_normal: 0,
        z_group_other_warn: 0,
        z_group_other_red: 0,

        z_out_normal: 0,
        z_out_warn: 0,
        z_out_red: 0
    }


    render template: "tickets/index"

  end

  private
  def is_login
    if !session[:is_login]
      redirect_to "/login"
    end
  end


end
