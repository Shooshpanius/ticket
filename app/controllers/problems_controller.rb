class ProblemsController < ApplicationController


  def in
    @problems = Problem.all
  end

  def out
    @my_problems = Problem.where("user_id = ? and status = ?", session[:user_id], 0)
  end

  def problem_new

  end

  def problem_edit
    @my_problem = Problem.find(params[:id])
    @initiator = User.find(@my_problem.user_id)

    @comments = Problem.find(params[:id]).ticket_comments
  end


  def srv_problem_new

      problem = Problem.new()
      problem.user_id = session[:user_id]
      problem.topic = params[:inputTopic]
      problem.text = params[:inputText]
      problem.status = 0
      problem.save

    render text: "srv_ticket_new"
  end



  def srv_comment_new
    Problem.comment_new(session[:user_id], params[:problem_id], params[:inputCommText])
    render text: "srv_comment_new"
  end

end
