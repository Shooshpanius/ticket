# encoding: utf-8
class SupplyController < ApplicationController

  protect_from_forgery
  before_filter :is_login



  ###################################################################################################################
  #
  #
  def in

    @form_data = {

    }

  end

  ###################################################################################################################
  #
  #
  def out

    out_supplies = TicketRoot.out_supplies(session[:user_id])

    @form_data = {
        out_supplies: out_supplies

    }

  end

  ###################################################################################################################
  #
  #
  def supply_new

    @form_data = {
        users: User.all,
        groups: Group.all,
    }


  end

  ###################################################################################################################
  #
  #
  def supply_edit

    @form_data = {
        users: User.all,
        groups: Group.all,
    }

  end


  ###################################################################################################################
  #
  #
  def srv_supply_new

    ticket_data = {
      initiator_id: session[:user_id],
      group_id: params[:inputIsp].scan(/\d/).join.to_i,
      topic: params[:inputTopic],
      text: params[:inputText],
      completed: 0,
      executor: 0,
      deadline: params[:inputDateTo],

    }
    ticket_supply = TicketToSupply.new(ticket_data)
    ticket_supply.save

    render :text => ticket_supply.id

  end





  private
  def is_login
    if !session[:is_login]
      redirect_to "/"
    end
  end

end
