class ActualTask < ActiveRecord::Base

  belongs_to :user
  belongs_to :ticket_to_group
  belongs_to :ticket_to_user


  def ActualTask.change_g_active(user_id, status, ticket_id)
    if TicketToGroup.is_member(user_id, ticket_id)
      if status == "true"
        actual_task = ActualTask.new()
        actual_task.user_id = user_id
        actual_task.ticket_to_group_id = ticket_id
        actual_task.save()
        return status
      else
        ActualTask.where(:ticket_to_group_id => ticket_id, :user_id => user_id).delete_all
        return status
      end
    end
  end

  def ActualTask.change_u_active(user_id, status, ticket_id)
    if TicketToGroup.is_initiator(user_id, ticket_id) or TicketToGroup.is_executor(user_id, ticket_id)
      if status == "true"
        actual_task = ActualTask.new()
        actual_task.user_id = user_id
        actual_task.ticket_to_user_id = ticket_id
        actual_task.save()
        return status
      else
        ActualTask.where(:ticket_to_user_id => ticket_id, :user_id => user_id).delete_all
        return status
      end
    end
  end

  def ActualTask.is_actual_g(user_id, ticket_id)
    return (ActualTask.where(ticket_to_group_id: ticket_id, :user_id => user_id).count == 0)?false:true
  end

  def ActualTask.is_actual_u(user_id, ticket_id)
    return (ActualTask.where(ticket_to_user_id: ticket_id, :user_id => user_id).count == 0)?false:true
  end





end
