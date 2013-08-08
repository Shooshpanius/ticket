class MailReceiverController < ApplicationController

  #require 'mail'

  def get_mail()

    #require 'net/ldap'
    ldap = Net::LDAP.new :host => '192.168.0.17',
                         :port => 389,
                         :auth => {
                             :method => :simple,
                             :username => "ticket@wood.local",
                             :password => "ticket"
                         }


    users = User.all

    users.each_with_index do |user, i|
      if user.ticket_email != nil
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
            @e_text =  email.parts[1].body.decoded.encode( 'UTF-8', 'koi8-r' )
          else
            @e_text = email.body.decoded.force_encoding("UTF-8")
          end
          @sndr = users.where("email = ? ", @e_from)

          if @sndr.size() != 0


          else

            filter = Net::LDAP::Filter.eq("mail", @e_from)
            attrs = ["givenName", "sn", "physicalDeliveryOfficeName", "sAMAccountName", "mail", "title", "department"]
            i = 0
            ldap.search(:base => "DC=wood,DC=local", :attributes => attrs, :return_result => true) do |entry|

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
              if new_user.new_record?
                new_user.save
                @sndr = new_user
              end

            end

            new_user = User.find_or_initialize_by(email: @e_from)
            new_user.login = @e_from
            new_user.password = pass_generate(8)
            new_user.email = @e_from
            if new_user.new_record?
              new_user.save
              @sndr = new_user
            end

          end

          #render ("get_mail")
        end
      end
    end
  end





end
