class TicketRoot < ActiveRecord::Base

  acts_as_tree order: "id"

  has_one :ticket_to_user, foreign_key: "root"
  has_one :ticket_to_group, foreign_key: "root"

  def TicketRoot.my_tickets(user_id)

    user_tickets = TicketRoot.find_by_sql("SELECT
                                            ticket_roots.*,
                                            ticket_to_users.root as t_root,
                                            ticket_to_users.user_id as t_user_id,
                                            ticket_to_users.actual as actual
                                           FROM ticket_roots
                                              LEFT JOIN ticket_to_users ON ticket_roots.id = ticket_to_users.root
                                           WHERE
                                              ticket_roots.ticket_type = 'u' AND ticket_to_users.user_id = #{user_id} AND ticket_to_users.completed != '100'
                                          ")

    group_tickets = TicketRoot.find_by_sql("SELECT
                                              ticket_roots.*,
                                              ticket_to_groups.root as t_root,
                                              ticket_to_groups.executor as t_executor,
                                              ticket_to_groups.actual as actual
                                            FROM ticket_roots
                                              LEFT JOIN ticket_to_groups ON ticket_roots.id = ticket_to_groups.root
                                            WHERE
                                            ticket_roots.ticket_type = 'g' AND ticket_to_groups.executor = #{user_id} AND ticket_to_groups.completed != '100'
                                            ")

    my_tickets = user_tickets + group_tickets

    my_tickets.each do |my_ticket|
      my_ticket[:actual] = (my_ticket.ticket_type == "g") ? ActualTask.is_actual_g(user_id, my_ticket.ticket_id) : ActualTask.is_actual_u(user_id, my_ticket.ticket_id)
    end
    my_tickets.sort! do |a, b|
      (b.actual <=> a.actual).nonzero? ||
          (b.created_at <=> a.created_at)
    end



    return my_tickets
  end


  def TicketRoot.other_tickets(user_id)

    my_groups = ""
    UserByGroup.groups_for_user(user_id).map{|x| x.id}.each do |y|
        my_groups = my_groups + (y.to_s+",")
    end
    my_groups = my_groups + ")"
    my_groups = my_groups.gsub(/(\,\))/,'')
    if UserByGroup.groups_for_user(user_id).size == 0 then
      return []
    end

    group_tickets = TicketRoot.find_by_sql("SELECT
                                              ticket_roots.*,
                                              ticket_to_groups.root as t_root,
                                              ticket_to_groups.executor as t_executor,
                                              ticket_to_groups.actual as actual
                                            FROM ticket_roots
                                              LEFT JOIN ticket_to_groups ON ticket_roots.id = ticket_to_groups.root
                                            WHERE
                                            ticket_roots.ticket_type = 'g' AND ticket_to_groups.executor != #{user_id} AND ticket_to_groups.group_id in (#{my_groups}) AND ticket_to_groups.completed != '100'
                                           ")

    group_tickets.each do |my_ticket|
      my_ticket[:actual] = ActualTask.is_actual_g(user_id, my_ticket.ticket_id)
    end
    group_tickets.sort! do |a, b|
      (b.actual <=> a.actual).nonzero? ||
          (b.created_at <=> a.created_at)
    end

    return group_tickets

  end

end

# AND ticket_to_groups.group_id IN #{my_groups}