class ProblemsController < ApplicationController


  def in


  end

  def out
    @my_proplems = Problem.where("user_id = ? and status != ?", session[:user_id], nil)


  end

  def problem_new



  end

  def problem_edit



  end


  def srv_problem_new

      problem = Problem.new()
      problem.user_id = session[:user_id]
      problem.topic = params[:inputTopic]
      problem.text = params[:inputText]
      problem.save

    render text: "srv_ticket_new"
  end

end
