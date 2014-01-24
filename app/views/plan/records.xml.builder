xml.instruct! :xml, :version=>"1.0"

xml.tag!("data") do #actual count of records need to be used here

    @form_data[:my_tickets].each do |record|
        xml.tag!("event",{ "id" => record.id }) do
        xml.tag!("text", record.id)
        end
    end

    @form_data[:other_tickets].each do |record|
      xml.tag!("event",{ "id" => record.id }) do
        xml.tag!("text", record.id)
        xml.tag!("start_date", record.start_scheduler )
        xml.tag!("end_date", record.stop_scheduler )
      end
    end

    @form_data[:out_tickets].each do |record|
      xml.tag!("event",{ "id" => record.id }) do
        xml.tag!("text", record.topic)
        xml.tag!("start_date", record.start_scheduler )
        xml.tag!("end_date", record.stop_scheduler )
      end
    end

end