class Problem < ActiveRecord::Base
  has_many :ticket_comments, dependent: :destroy


  def Problem.is_member(user_id, problem_id)
    @problem = Problem.find(problem_id)
    @initiator = User.find(@problem.user_id)

    if UserByGroup.where("group_id in (?) AND user_id = ?", UserByGroup.groups_for_user(@initiator.id), user_id).size != 0
      return true
    else
      return false
    end
  end


  def Problem.comment_new(user_id, problem_id, inputCommText)
    if Problem.is_member(user_id, problem_id)
      @user_comment = TicketComment.new()
      @user_comment.user_id = user_id
      @user_comment.problem_id = problem_id
      @user_comment.text = inputCommText
      @user_comment.save()
    end
  end

end
