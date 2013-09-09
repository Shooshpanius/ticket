# encoding: utf-8
class TicketRoot < ActiveRecord::Base

  acts_as_tree order: "id"

  has_one :ticket_to_user, foreign_key: "root"
  has_one :ticket_to_group, foreign_key: "root"

  #
  #  TicketRoot.my_tickets(user_id)
  #
  def TicketRoot.my_tickets(user_id)

    user_tickets = TicketRoot.find_by_sql("SELECT
                                            ticket_roots.*,
                                            ticket_to_users.root as t_root,
                                            ticket_to_users.user_id as t_user_id,
                                            ticket_to_users.actual as actual
                                           FROM ticket_roots
                                              LEFT JOIN ticket_to_users ON ticket_roots.id = ticket_to_users.root
                                           WHERE
                                              ticket_roots.ticket_type = 'u' AND
                                              ticket_to_users.user_id = #{user_id} AND
                                              ticket_to_users.completed != '100' AND
                                               (ticket_roots.delay < '#{Time.now}' OR ticket_roots.delay IS NULL)
                                          ")

    group_tickets = TicketRoot.find_by_sql("SELECT
                                              ticket_roots.*,
                                              ticket_to_groups.root as t_root,
                                              ticket_to_groups.executor as t_executor,
                                              ticket_to_groups.actual as actual
                                            FROM ticket_roots
                                              LEFT JOIN ticket_to_groups ON ticket_roots.id = ticket_to_groups.root
                                            WHERE
                                              ticket_roots.ticket_type = 'g' AND
                                              ticket_to_groups.executor = #{user_id} AND
                                              ticket_to_groups.completed != '100' AND
                                               (ticket_roots.delay < '#{Time.now}' OR ticket_roots.delay IS NULL)
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



  #
  #  TicketRoot.my_tickets_cnt(user_id)
  #
  def TicketRoot.my_tickets_cnt(user_id)

    user_tickets = TicketRoot.find_by_sql("SELECT SQL_CALC_FOUND_ROWS
                                            ticket_roots.*,
                                            ticket_to_users.root as t_root,
                                            ticket_to_users.user_id as t_user_id,
                                            ticket_to_users.actual as actual
                                           FROM ticket_roots
                                              LEFT JOIN ticket_to_users ON ticket_roots.id = ticket_to_users.root
                                           WHERE
                                              ticket_roots.ticket_type = 'u' AND
                                              ticket_to_users.user_id = #{user_id} AND
                                              ticket_to_users.completed != '100' AND
                                               (ticket_roots.delay < '#{Time.now}' OR ticket_roots.delay IS NULL)
                                          ")

    group_tickets = TicketRoot.find_by_sql("SELECT SQL_CALC_FOUND_ROWS
                                              ticket_roots.*,
                                              ticket_to_groups.root as t_root,
                                              ticket_to_groups.executor as t_executor,
                                              ticket_to_groups.actual as actual
                                            FROM ticket_roots
                                              LEFT JOIN ticket_to_groups ON ticket_roots.id = ticket_to_groups.root
                                            WHERE
                                              ticket_roots.ticket_type = 'g' AND
                                              ticket_to_groups.executor = #{user_id} AND
                                              ticket_to_groups.completed != '100' AND
                                               (ticket_roots.delay < '#{Time.now}' OR ticket_roots.delay IS NULL)
                                            ")

    my_tickets = user_tickets.size + group_tickets.size

    return my_tickets
  end


  #
  #  TicketRoot.other_tickets(user_id)
  #
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
                                              ticket_roots.ticket_type = 'g' AND
                                              ticket_to_groups.executor != #{user_id} AND
                                              ticket_to_groups.group_id in (#{my_groups}) AND
                                              ticket_to_groups.completed != '100' AND
                                               (ticket_roots.delay < '#{Time.now}' OR ticket_roots.delay IS NULL)
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




  #
  #  TicketRoot.other_tickets_delay(user_id)
  #
  def TicketRoot.other_tickets_delay(user_id)

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
                                              ticket_roots.ticket_type = 'g' AND
                                              ticket_to_groups.executor != #{user_id} AND
                                              ticket_to_groups.group_id in (#{my_groups}) AND
                                              ticket_to_groups.completed != '100' AND
                                              ticket_roots.delay > '#{Time.now}'
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




  #
  #  TicketRoot.my_tickets_delay(user_id)
  #
  def TicketRoot.my_tickets_delay(user_id)

    user_tickets = TicketRoot.find_by_sql("SELECT
                                            ticket_roots.*,
                                            ticket_to_users.root as t_root,
                                            ticket_to_users.user_id as t_user_id,
                                            ticket_to_users.actual as actual
                                           FROM ticket_roots
                                              LEFT JOIN ticket_to_users ON ticket_roots.id = ticket_to_users.root
                                           WHERE
                                              ticket_roots.ticket_type = 'u' AND
                                              ticket_to_users.user_id = #{user_id} AND
                                              ticket_to_users.completed != '100' AND
                                              ticket_roots.delay > '#{Time.now}'
                                          ")

    group_tickets = TicketRoot.find_by_sql("SELECT
                                              ticket_roots.*,
                                              ticket_to_groups.root as t_root,
                                              ticket_to_groups.executor as t_executor,
                                              ticket_to_groups.actual as actual
                                            FROM ticket_roots
                                              LEFT JOIN ticket_to_groups ON ticket_roots.id = ticket_to_groups.root
                                            WHERE
                                              ticket_roots.ticket_type = 'g' AND
                                              ticket_to_groups.executor = #{user_id} AND
                                              ticket_to_groups.completed != '100' AND
                                              ticket_roots.delay > '#{Time.now}'
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



  #
  #  TicketRoot.my_tickets_delay_cnt(user_id)
  #
  def TicketRoot.my_tickets_delay_cnt(user_id)

    user_tickets = TicketRoot.find_by_sql("SELECT SQL_CALC_FOUND_ROWS
                                            ticket_roots.*,
                                            ticket_to_users.root as t_root,
                                            ticket_to_users.user_id as t_user_id,
                                            ticket_to_users.actual as actual
                                           FROM ticket_roots
                                              LEFT JOIN ticket_to_users ON ticket_roots.id = ticket_to_users.root
                                           WHERE
                                              ticket_roots.ticket_type = 'u' AND
                                              ticket_to_users.user_id = #{user_id} AND
                                              ticket_to_users.completed != '100' AND
                                              ticket_roots.delay > '#{Time.now}'
                                          ")

    group_tickets = TicketRoot.find_by_sql("SELECT SQL_CALC_FOUND_ROWS
                                              ticket_roots.*,
                                              ticket_to_groups.root as t_root,
                                              ticket_to_groups.executor as t_executor,
                                              ticket_to_groups.actual as actual
                                            FROM ticket_roots
                                              LEFT JOIN ticket_to_groups ON ticket_roots.id = ticket_to_groups.root
                                            WHERE
                                              ticket_roots.ticket_type = 'g' AND
                                              ticket_to_groups.executor = #{user_id} AND
                                              ticket_to_groups.completed != '100' AND
                                              ticket_roots.delay > '#{Time.now}'
                                            ")

    my_tickets = user_tickets.size + group_tickets.size

    return my_tickets
  end



  #
  #  TicketRoot.out_tickets(user_id)
  #
  def TicketRoot.out_tickets(user_id)

    user_tickets = TicketRoot.find_by_sql("SELECT
                                            ticket_roots.*,
                                            ticket_to_users.root as t_root,
                                            ticket_to_users.initiator_id as t_initiator_id 	,
                                            ticket_to_users.actual as actual
                                           FROM ticket_roots
                                              LEFT JOIN ticket_to_users ON ticket_roots.id = ticket_to_users.root
                                           WHERE
                                              ticket_roots.ticket_type = 'u' AND
                                              ticket_to_users.initiator_id = #{user_id} AND
                                              ticket_to_users.completed != '100'
                                          ")

    group_tickets = TicketRoot.find_by_sql("SELECT
                                              ticket_roots.*,
                                              ticket_to_groups.root as t_root,
                                              ticket_to_groups.initiator_id as t_initiator_id,
                                              ticket_to_groups.actual as actual
                                            FROM ticket_roots
                                              LEFT JOIN ticket_to_groups ON ticket_roots.id = ticket_to_groups.root
                                            WHERE
                                              ticket_roots.ticket_type = 'g' AND
                                              ticket_to_groups.initiator_id = #{user_id} AND
                                              ticket_to_groups.completed != '100'
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



  #
  #  TicketRoot.out_tickets_cnt(user_id)
  #
  def TicketRoot.out_tickets_cnt(user_id)

    user_tickets = TicketRoot.find_by_sql("SELECT SQL_CALC_FOUND_ROWS
                                            ticket_roots.*,
                                            ticket_to_users.root as t_root,
                                            ticket_to_users.initiator_id as t_initiator_id 	,
                                            ticket_to_users.actual as actual
                                           FROM ticket_roots
                                              LEFT JOIN ticket_to_users ON ticket_roots.id = ticket_to_users.root
                                           WHERE
                                              ticket_roots.ticket_type = 'u' AND
                                              ticket_to_users.initiator_id = #{user_id} AND
                                              ticket_to_users.completed != '100'
                                          ")

    group_tickets = TicketRoot.find_by_sql("SELECT SQL_CALC_FOUND_ROWS
                                              ticket_roots.*,
                                              ticket_to_groups.root as t_root,
                                              ticket_to_groups.initiator_id as t_initiator_id,
                                              ticket_to_groups.actual as actual
                                            FROM ticket_roots
                                              LEFT JOIN ticket_to_groups ON ticket_roots.id = ticket_to_groups.root
                                            WHERE
                                              ticket_roots.ticket_type = 'g' AND
                                              ticket_to_groups.initiator_id = #{user_id} AND
                                              ticket_to_groups.completed != '100'
                                            ")

    my_tickets = user_tickets.size + group_tickets.size

    return my_tickets
  end







  def TicketRoot.set_delay(delay_data)
    root = TicketRoot.find(delay_data[:root_id])
    ticket_type = root.ticket_type

    if ticket_type = "g"
      if TicketToGroup.is_leader(delay_data[:user_id], root.ticket_id) == true || TicketToGroup.is_executor(delay_data[:user_id], root.ticket_id) == true  then
        root.delay = delay_data[:delay_date] + " " + delay_data[:delay_time] + ":00"
        root.save
        TicketToGroup.comment_new(delay_data[:user_id], root.ticket_id, "Заявка отложена до " + root.delay.strftime("%d-%m-%Y %H:%M") + " с комментарием: " + delay_data[:delay_comment])
      end
      #return TicketToGroup.is_leader(delay_data[:user_id], root.ticket_id).to_s + "___" + TicketToGroup.is_executor(delay_data[:user_id], root.ticket_id).to_s
    end

  end



  def TicketRoot.set_delay_off(delay_data)
    root = TicketRoot.find(delay_data[:root_id])
    ticket_type = root.ticket_type

    if ticket_type = "g"
      if TicketToGroup.is_leader(delay_data[:user_id], root.ticket_id) == true || TicketToGroup.is_executor(delay_data[:user_id], root.ticket_id) == true  then
        root.delay = nil
        root.save
      end
      #return TicketToGroup.is_leader(delay_data[:user_id], root.ticket_id).to_s + "___" + TicketToGroup.is_executor(delay_data[:user_id], root.ticket_id).to_s
    end

  end


end

# AND ticket_to_groups.group_id IN #{my_groups}