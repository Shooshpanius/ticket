xml.instruct! :xml, :version=>"1.0"

xml.tag!("data") do #actual count of records need to be used here

    @form_data[:my_tickets].each do |record|
      if (record.start_scheduler != nil) && (record.stop_scheduler != nil)
        if (record.start_scheduler < record.stop_scheduler)
          ticket = TicketRoot.get_ticket(session[:user_id], record.ticket_root_id)

          xml.tag!("event",{ "id" => record.id }) do
            xml.tag!("text", ticket.topic)
            xml.tag!("start_date", record.start_scheduler )
            xml.tag!("end_date", record.stop_scheduler )
          end
        end
      end
    end

end