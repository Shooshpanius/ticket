class TicketRoot < ActiveRecord::Base

  acts_as_tree order: "id"

  has_one :ticket_to_user, foreign_key: "root"
  has_one :ticket_to_group, foreign_key: "root"

  def TicketRoot.my_tickets(user_id)

    user_tickets = TicketRoot.find_by_sql("SELECT ticket_roots.*, ticket_to_users.root as t_root, ticket_to_users.user_id as t_user_id
                                           FROM ticket_roots
                                              LEFT JOIN ticket_to_users ON ticket_roots.id = ticket_to_users.root
                                           WHERE
                                              ticket_roots.ticket_type = 'u' AND ticket_to_users.user_id = #{user_id}
                                          ")

    group_tickets = TicketRoot.find_by_sql("SELECT ticket_roots.*, ticket_to_groups.root as t_root, ticket_to_groups.executor as t_executor
                                            FROM ticket_roots
                                              LEFT JOIN ticket_to_groups ON ticket_roots.id = ticket_to_groups.root
                                            WHERE
                                            ticket_roots.ticket_type = 'g' AND ticket_to_groups.executor = #{user_id}
                                            ")

    return user_tickets + group_tickets
  end


  def TicketRoot.other_tickets(user_id)

    #user_tickets = TicketRoot.find_by_sql("SELECT ticket_roots.*, ticket_to_users.root as t_root, ticket_to_users.user_id as t_user_id
    #                                       FROM ticket_roots
    #                                          LEFT JOIN ticket_to_users ON ticket_roots.id = ticket_to_users.root
    #                                       WHERE
    #                                          ticket_roots.ticket_type = 'u' AND ticket_to_users.user_id != #{user_id}
    #                                      ")

    my_groups = ""
    UserByGroup.groups_for_user(user_id).map{|x| x.id}.each do |y|
        my_groups = my_groups + (y.to_s+",")
    end
    my_groups = my_groups + ")"

    my_groups = my_groups.gsub(/(\,\))/,'')

    #if UserByGroup.groups_for_user(user_id).size == 0 then
    #
    #  return []
    #
    #
    #end


    group_tickets = TicketRoot.find_by_sql("SELECT ticket_roots.*, ticket_to_groups.root as t_root, ticket_to_groups.executor as t_executor
                                            FROM ticket_roots
                                              LEFT JOIN ticket_to_groups ON ticket_roots.id = ticket_to_groups.root
                                            WHERE
                                            ticket_roots.ticket_type = 'g' AND ticket_to_groups.executor != #{user_id} AND ticket_to_groups.group_id in (#{my_groups})
                                           ")

    return group_tickets
  end

end

# AND ticket_to_groups.group_id IN #{my_groups}