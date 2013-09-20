# encoding: utf-8
class SupplyController < ApplicationController

  protect_from_forgery
  before_filter :is_login

  require "prawn"

  ###################################################################################################################
  #
  #
  def in

    @form_data = {
      supplies: TicketRoot.in_supplies(session[:user_id])
    }

  end

  ###################################################################################################################
  #
  #
  def out

    @form_data = {
      out_supplies: TicketRoot.out_supplies(session[:user_id])
    }

  end

  ###################################################################################################################
  #
  #
  def supply_new

    if params[:id] == nil
      @form_data = {
        users: User.all,
        groups: Group.all,
      }
    else

      if params[:id].scan(/g_/)[0]
        ticket_id = params[:id].scan(/\d/).join.to_i
        if TicketToGroup.is_initiator(session[:user_id], ticket_id)==true || TicketToGroup.is_executor(session[:user_id], ticket_id)==true ||
            TicketToGroup.is_member(session[:user_id], ticket_id)==true || TicketToGroup.is_leader(session[:user_id], ticket_id)==true
        then
          @form_data = {
              users: User.all,
              groups: Group.all,
              root_ticket: TicketRoot.find( TicketToGroup.find(ticket_id).root ),
              ticket: TicketToGroup.find(ticket_id),

          }
        else
          redirect_to "/"
        end
      end

    end



  end

  ###################################################################################################################
  #
  #
  def supply_edit

    ticket = TicketToSupply.find(params[:id])
    ticket_id = params[:id]

    if TicketToSupply.is_initiator(session[:user_id], ticket_id)==true || TicketToSupply.is_executor(session[:user_id], ticket_id)==true ||
        TicketToSupply.is_member(session[:user_id], ticket_id)==true || TicketToSupply.is_leader(session[:user_id], ticket_id)==true
    then

      @form_data = {
          ticket_id: params[:id],
          ticket: ticket,
          ticket_root: TicketRoot.where("ticket_type = ? AND ticket_id = ?", "s", params[:id])[0],
          initiator: User.find(ticket.initiator_id),
          group: Group.find(ticket.group_id),
          supply_data: SupplyData.where("root = ?", ticket.root),
      }
      render "supply_edit"
    end

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
      deadline: params[:inputDateTo]
    }

    ticket_supply = TicketToSupply.new(ticket_data)
    ticket_supply.save

    render :text => ticket_supply.id

  end



  ###################################################################################################################
  #
  #
  def srv_add_supply_data

    supply_data = {
        ticket_id: params[:inputAddTicket],
        root: params[:inputAddRoot],
        name: params[:inputAddName],
        spec: params[:inputAddSpec],
        measure: params[:inputAddMeasure],
        cnt: params[:inputAddCnt],
        estimated_date: params[:inputAddDate],
        supplier: params[:inputAddSupplier],
    }

    if TicketToSupply.is_initiator(session[:user_id], params[:inputAddTicket])
      supply = SupplyData.new(supply_data)
      supply.save
    end

    render :nothing => true
    #render :text => supply.id

  end







  ###################################################################################################################
  #
  #
  def download

    supply = TicketToSupply.find(params[:id])
    supply_data = SupplyData.where("root = ?", supply.root)
    user = User.find(session[:user_id])

    output = Pdf.new.to_pdf(supply, supply_data, user)
    send_data output, :type => 'application/pdf', :filename => "public/pdf/supply_#{params[:id]}.pdf"


  end




  private
  def is_login
    if !session[:is_login]
      redirect_to "/"
    end
  end

end
