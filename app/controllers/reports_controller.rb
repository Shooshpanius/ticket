class ReportsController < ApplicationController

  before_filter :is_login


  def activity




  end


  def srv_activity


    #user_comments = TicketComment.where('user_id = (?)',  session[:user_id] )
    #user_comments = TicketComment.where('created_at >= (?) and created_at <= (?) and user_id = (?)', params[:inputDateFrom].to_time.to_i, params[:inputDateTo].to_time.to_i, session[:user_id] )
    user_comments = TicketComment.where('created_at >= (?) and created_at <= (?) and user_id = (?)', params[:inputDateFrom].to_time.to_datetime, params[:inputDateTo].to_time.to_datetime, session[:user_id] )

    @form_data = {
      user_comments: user_comments,
      inputDateFrom: params[:inputDateFrom].to_time.to_datetime ,
      inputDateTo: params[:inputDateTo].to_time.to_datetime
    }

    render(:layout => false)

  end


  private
  def is_login
    unless session[:is_login]
      redirect_to "/"
    end
  end

end
