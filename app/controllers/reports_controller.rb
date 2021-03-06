class ReportsController < ApplicationController

  before_filter :is_login


  def activity




  end


  def srv_activity
    user_comments = TicketComment.where('created_at >= (?) and created_at <= (?) and user_id = (?)', params[:inputDateFrom].to_time.to_datetime, params[:inputDateTo].to_time.to_datetime.next, params[:inputIsp] )
    @form_data = {
      user_comments: user_comments
    }
    render(:layout => false)
  end



  def srv_activity_show_text

    begin
      render text: TicketRoot.get_ticket(session[:user_id],params[:root_id]).text
    rescue
      render text: "Not found"
    end


  end




  private
  def is_login
    unless session[:is_login]
      redirect_to "/"
    end
  end

end
