class PlanController < ApplicationController

  before_filter :is_login


  def index



  end


  def records

    my_tickets = TicketRoot.my_tickets(session[:user_id])
    other_tickets = TicketRoot.other_tickets(session[:user_id])
    out_tickets = TicketRoot.out_tickets(session[:user_id])

    @form_data = {
        my_tickets: my_tickets,
        other_tickets: other_tickets,
        out_tickets: out_tickets
    }

  end


  def edit_task

    root = TicketRoot.find(params[:id])

    ticket_type = root.ticket_type
    ticket_id = root.ticket_id

    if (ticket_type == 'u' && TicketToUser.is_initiator(session[:user_id], ticket_id)==false && TicketToUser.is_executor(session[:user_id], ticket_id)==false) or
       (ticket_type == 'g') && (TicketToGroup.is_initiator(session[:user_id], ticket_id)==true || TicketToGroup.is_executor(session[:user_id], ticket_id)==true ||
            TicketToGroup.is_member(session[:user_id], ticket_id)==true || TicketToGroup.is_leader(session[:user_id], ticket_id)==true)


      @form_data = {

      }


    end


  end



  private
  def is_login
    unless session[:is_login]
      redirect_to "/"
    end
  end


end
