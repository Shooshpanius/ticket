class TicketChildren < ActiveRecord::Base

  def TicketChildren.children_group_ticket_count(ticket_id)

  return  find_by_sql("SELECT * FROM ticket_children
                                        LEFT JOIN ticket_to_groups ON ticket_children.children_group_ticket_id = ticket_to_groups.id
                                        WHERE ticket_children.parent_group_ticket_id = #{ticket_id}
                                           AND ticket_to_groups.completed != 100").size
  end
end
