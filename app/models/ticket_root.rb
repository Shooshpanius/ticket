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

    user_tickets = TicketRoot.find_by_sql("SELECT ticket_roots.*, ticket_to_users.root as t_root, ticket_to_users.user_id as t_user_id
                                           FROM ticket_roots
                                              LEFT JOIN ticket_to_users ON ticket_roots.id = ticket_to_users.root
                                           WHERE
                                              ticket_roots.ticket_type = 'u' AND ticket_to_users.user_id != #{user_id}
                                          ")

    group_tickets = TicketRoot.find_by_sql("SELECT ticket_roots.*, ticket_to_groups.root as t_root, ticket_to_groups.executor as t_executor
                                            FROM ticket_roots
                                              LEFT JOIN ticket_to_groups ON ticket_roots.id = ticket_to_groups.root
                                            WHERE
                                            ticket_roots.ticket_type = 'g' AND ticket_to_groups.executor != #{user_id}
                                           ")

    return user_tickets + group_tickets
  end

end
