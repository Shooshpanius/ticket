class TicketToSupply < ActiveRecord::Base


  after_create :create_root



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
