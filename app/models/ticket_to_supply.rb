class TicketToSupply < ActiveRecord::Base


  after_create :create_root



  def TicketToSupply.is_initiator(user_id, ticket_id)
    ticket = TicketToSupply.find(ticket_id)
    if ticket.initiator_id == user_id
      return true
    else
      return false
    end
  end


  def TicketToSupply.is_member(user_id, ticket_id)
    ticket = TicketToSupply.find(ticket_id)
    if UserByGroup.where("group_id = ? AND user_id = ?", ticket.group_id, user_id).size != 0
      return true
    else
      return false
    end
  end


  def TicketToSupply.is_executor(user_id, ticket_id)
    ticket = TicketToSupply.find(ticket_id)
    if (ticket.executor == user_id) then
      return true
    else
      return false
    end
  end


  def TicketToSupply.is_leader(user_id, ticket_id)
    ticket = TicketToSupply.find(ticket_id)
    group = Group.find(ticket.group_id)
    if (group.leader == user_id) then
      return true
    else
      return false
    end
  end



  def create_root

    root_array = {
        ticket_type: "s",
        ticket_id: self.id,
        from_id: self.initiator_id,
        to_id: self.group_id,
        parent_id: 0
    }
    root = TicketRoot.new(root_array)
    root.save

    self.root = root.id
    self.save

  end



end
