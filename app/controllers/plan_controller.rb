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


  private
  def is_login
    unless session[:is_login]
      redirect_to "/"
    end
  end


end
