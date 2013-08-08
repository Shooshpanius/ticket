class MailReceiverController < ApplicationController

  #require 'mail'

  def get_mail()

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
            new_user = User.new()
            new_user.login = @e_from
            new_user.password = pass_generate(8)
            new_user.email = @e_from
            new_user.save
            @sndr = new_user
          end

          #render ("get_mail")
        end
      end
    end
  end





end
