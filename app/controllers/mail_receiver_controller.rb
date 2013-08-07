class MailReceiverController < ApplicationController

  require 'mail'

  def get_mail()

    users = User.all
    @a = ""
    @ticket_emails = Array.new(size=0, obj=nil)
    users.each_with_index do |user, i|
      if user.ticket_email != nil
        @ticket_emails[i] = user.ticket_email


        Mail.defaults do
          retriever_method :pop3, :address    => "192.168.0.207",
                           :port       => 110,
                           :user_name  => user.ticket_email,
                           :password   => user.ticket_email_password,
                           :enable_ssl => false
        end

        @a = Array.new(size=0, obj=nil)
        @emails = Mail.all
        @emails.each_with_index do |email, e|

          @a[e] = email.envelope.from

          #@a[e] = mail.from.addresses
          #@a[e] = mail.sender.address  #=> 'mikel@test.lindsaar.net'
          #@a[e] = mail.to              #=> 'bob@test.lindsaar.net'
          #@a[e] = mail.cc              #=> 'sam@test.lindsaar.net'
          #@a[e] = mail.subject         #=> "This is the subject"
          #@a[e] = mail.date.to_s       #=> '21 Nov 1997 09:55:06 -0600'
          #@a[e] = mail.message_id      #=> '<4D6AA7EB.6490534@xxx.xxx>'
          #@a[e] = mail.body.decoded





        end



      end


    end


  end





end
