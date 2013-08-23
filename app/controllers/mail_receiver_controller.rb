# encoding: utf-8
class MailReceiverController < ApplicationController

  #require 'mail'

  def get_mail()



    users = User.where("ticket_email != ?", "")
    ticket_type = 'user'
    users.each_with_index do |user, i|
      get_mail_process(user, i, ticket_type)
    end

    groups = Group.all
    ticket_type = 'group'
    groups.each_with_index do |user, i|
      get_mail_process(user, i, ticket_type)
    end





  end



  private
  def get_mail_process(user, i, ticket_type)

    require 'net/ldap'
    ldap = Net::LDAP.new :host => '192.168.0.17',
                         :port => 389,
                         :auth => {
                             :method => :simple,
                             :username => "ticket@wood.local",
                             :password => "ticket"
                         }

    if user.ticket_email.size > 3
      rcpt = user
      Mail.defaults do
        retriever_method :pop3, :address    => "192.168.0.207",
                         :port       => 110,
                         :user_name  => user.ticket_email,
                         :password   => user.ticket_email_password,
                         :enable_ssl => false
      end

      emails = Mail.all
      Mail.delete_all

      emails.each_with_index do |email, e|

        @e_from = email.from.to_s.strip.sub(/(\[\")/,'').sub(/(\"\])/,'')
        e_subj = email.subject
        if email.multipart? == true

          begin
            @e_text_t =  email.html_part.body.decoded.encode( 'UTF-8', email.html_part.content_type_parameters[:charset] )
          rescue Exception => e
            @e_text_t =  email.parts[0].body.decoded.encode( 'UTF-8', email.parts[0].content_type_parameters[:charset] )
          end

          #@e_text_t =  email.parts[0].body.decoded.encode( 'UTF-8', email.parts[0].content_type_parameters[:charset] )
          #@e_text =  email.parts[1].body.decoded.encode( 'UTF-8', email.parts[0].content_type_parameters[:charset] )
          #marker = " _q1"
        else
          begin
            @e_text_t =  email.html_part.body.decoded.encode( 'UTF-8', email.text_part.content_type_parameters[:charset] )
          rescue Exception => e
            @e_text_t =  email.body.decoded.encode( 'UTF-8', email.content_type_parameters[:charset] )
          end


          #@e_text = email.body.decoded.force_encoding("UTF-8")
          #marker = " _q2"
        end
        @sndr = User.where("email = ? ", @e_from)

        if @sndr.size() != 0
          @sndr = @sndr[0]

        else

          filter = Net::LDAP::Filter.eq("mail", @e_from)
          attrs = ["givenName", "sn", "physicalDeliveryOfficeName", "sAMAccountName", "mail", "title", "department"]
          i = 0
          ldap.search(:base => "DC=wood,DC=local", :filter => filter, :attributes => attrs, :return_result => true) do |entry|
            i += 0
            givenName = entry.try(:givenName).to_s.strip.sub(/(\[\")/,'').sub(/(\"\])/,'')
            sn = entry.try(:sn).to_s.strip.sub(/(\[\")/,'').sub(/(\"\])/,'')
            #username = entry.try(:username).to_s.strip
            sAMAccountName = entry.try(:sAMAccountName).to_s.strip.sub(/(\[\")/,'').sub(/(\"\])/,'')
            #office = entry.try(:office).to_s.strip
            mail = entry.try(:mail).to_s.strip.sub(/(\[\")/,'').sub(/(\"\])/,'')
            title = entry.try(:title).to_s.strip.sub(/(\[\")/,'').sub(/(\"\])/,'')
            department = entry.try(:department).to_s.strip.sub(/(\[\")/,'').sub(/(\"\])/,'')

            new_user = User.find_or_initialize_by(email: @e_from)
            new_user.login = sAMAccountName
            new_user.f_name = sn
            new_user.i_name = givenName
            new_user.position = title
            new_user.department = department
            new_user.password = pass_generate(8)
            if new_user.new_record?
              new_user.save
              @check = i
              @entry = entry
              @sndr = new_user
            end

          end

          new_user = User.find_or_initialize_by(email: @e_from)
          new_user.login = @e_from
          new_user.password = pass_generate(8)
          new_user.email = @e_from
          if new_user.new_record?
            new_user.save
            @check = "q"
            @entry = entry
            @sndr = new_user
          end

        end

        if ticket_type == "user"
          ticket = TicketToUser.new()
          ticket.initiator_id = @sndr.id
          ticket.user_id = rcpt.id
          (e_subj.strip != "") ? ticket.topic = e_subj : ticket.topic = "< Без темы >"
          ticket.text = @e_text_t
          ticket.completed = 0
          ticket.deadline = Date.today.next.next.next
          ticket.save

          email.attachments.each do | attachment |
            # Attachments is an AttachmentsList object containing a
            # number of Part objects
            #if (attachment.content_type.start_with?('image/'))
              # extracting images for example...
              filename = attachment.filename
              begin
                ext = File.extname(filename)
                salt = pass_generate(len=7)
                hash = Digest::MD5.hexdigest(Time.now.to_s + salt.to_s)
                new_filename = hash+"."+filename
                mime = MIME::Types.type_for(filename).first.content_type
                File.open("public/attache/" + new_filename, "w+b", 0644) {|f| f.write attachment.body.decoded}



                attach_data = {
                    object_type: "user_ticket",
                    object_id: ticket.id,
                    original_filename: filename,
                    filename: new_filename,
                    mime: mime
                }

                attach = Attach.new(attach_data)
                attach.save


              rescue Exception => e
                puts "Unable to save data for #{filename} because #{e.message}"
              end
            #end
          end


        end

        if ticket_type == "group"
          ticket = TicketToGroup.new()
          ticket.initiator_id = @sndr.id
          ticket.group_id = rcpt.id
          (e_subj.strip != "") ? ticket.topic = e_subj : ticket.topic = "< Без темы >"
          ticket.text = @e_text_t
          ticket.completed = 0
          ticket.executor = 0
          ticket.deadline = Date.today.next.next.next
          ticket.save



          email.attachments.each do | attachment |
            # Attachments is an AttachmentsList object containing a
            # number of Part objects
            #if (attachment.content_type.start_with?('image/'))
            # extracting images for example...
            filename = attachment.filename
            begin
              ext = File.extname(filename)
              salt = pass_generate(len=7)
              hash = Digest::MD5.hexdigest(Time.now.to_s + salt.to_s)
              new_filename = hash+"."+filename
              mime = MIME::Types.type_for(filename).first.content_type
              File.open("public/attache/" + new_filename, "w+b", 0644) {|f| f.write attachment.body.decoded}

              attach_data = {
                  object_type: "group_ticket",
                  object_id: ticket.id,
                  original_filename: filename,
                  filename: new_filename,
                  mime: mime
              }

              attach = Attach.new(attach_data)
              attach.save


            rescue Exception => e
              puts "Unable to save data for #{filename} because #{e.message}"
            end
            #end
          end
        end
      end
    end
  end

end
