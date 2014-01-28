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
          ticket: TicketRoot.get_ticket(session[:user_id], root.id),
          root: root,
          plan_data: Plan.where('sender_id = ?', session[:user_id])
      }
    end
  end

  def srv_add_task

    root = TicketRoot.find(params[:root_id])
    ticket_type = root.ticket_type
    ticket_id = root.ticket_id
    if (ticket_type == 'u' && TicketToUser.is_initiator(session[:user_id], ticket_id)==false && TicketToUser.is_executor(session[:user_id], ticket_id)==false)

    end

    if (ticket_type == 'g') && (TicketToGroup.is_initiator(session[:user_id], ticket_id)==true || TicketToGroup.is_executor(session[:user_id], ticket_id)==true ||
            TicketToGroup.is_member(session[:user_id], ticket_id)==true || TicketToGroup.is_leader(session[:user_id], ticket_id)==true)
      Plan.create(
          sender_id: session[:user_id],
          recipient_id: params[:task_to],
          ticket_root_id: params[:root_id],
          start_scheduler: params[:startScheduler],
          stop_scheduler: params[:stopScheduler]
      )


    end

    render :nothing => true
  end


  private
  def is_login
    unless session[:is_login]
      redirect_to "/"
    end
  end


end
