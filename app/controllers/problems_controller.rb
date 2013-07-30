class ProblemsController < ApplicationController


  def in


  end

  def out
    @my_problems = Problem.where("user_id = ? and status = ?", session[:user_id], 0)


  end

  def problem_new
    @my_groups_text = ''
    @my_groups = UserByGroup.groups_for_user(session[:user_id]).each do |user_groups|
      g = Group.find(user_groups.id)
      @my_groups_text += (g.name+'; ')
    end
  end

  def problem_edit
    @my_problem = Problem.find(params[:id])

    @my_groups_text = ''
    @my_groups = UserByGroup.groups_for_user(@my_problem.user_id).each do |user_groups|
      g = Group.find(user_groups.id)
      @my_groups_text += (g.name+'; ')
    end




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

end
