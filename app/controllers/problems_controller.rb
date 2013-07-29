class ProblemsController < ApplicationController


  def in


  end

  def out



  end

  def problem_new



  end


  def srv_problem_new

      @ticket = Problem.new()
      @ticket.user_id = session[:user_id]
      @ticket.topic = params[:inputTopic]
      @ticket.text = params[:inputText]
      @ticket.save

    render text: "srv_ticket_new"
  end

end
