class MailReceiverController < ApplicationController

  #require 'mail'

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

        @a = []
        @emails = Mail.first


        #@emails.each_with_index do |email, e|

          #@a[e] = email.envelope.from


          @a[10] = @emails.multipart?          #=> true
          @a[11] = @emails.parts.length        #=> 2
          @a[12] = @emails.body.preamble       #=> "Text before the first part"
          @a[13] = @emails.body.epilogue       #=> "Text after the last part"
          @a[14] = @emails.parts.map { |p| p.content_type }  #=> ['text/plain', 'application/pdf']
          @a[15] = @emails.parts.map { |p| p.class }         #=> [Mail::Message, Mail::Message]
          @a[16] = @emails.parts[0].content_type_parameters  #=> {'charset' => 'ISO-8859-1'}
          @a[17] = @emails.parts[1].content_type_parameters  #=> {'name' => 'my.pdf'}
        @a[18] = @emails.text_part # finds the first text/plain part
        @a[19] = @emails.html_part # finds the first text/html part
        @a[20] = @emails.parts[0].body.decoded # finds the first text/html part
        @a[21] = @emails.parts[1].body.decoded # finds the first text/html part
        @a[22] = @emails.parts[0].body # finds the first text/html part
        @a[23] = @emails.parts[1].body # finds the first text/html part

          @a[0] = @emails.from
          @a[1] = @emails.sender  #=> 'mikel@test.lindsaar.net'
          @a[2] = @emails.to              #=> 'bob@test.lindsaar.net'
          @a[3] = @emails.cc              #=> 'sam@test.lindsaar.net'
          @a[4] = @emails.subject         #=> "This is the subject"
          @a[5] = @emails.date.to_s       #=> '21 Nov 1997 09:55:06 -0600'
          @a[6] = @emails.message_id      #=> '<4D6AA7EB.6490534@xxx.xxx>'
          @a[7] = @emails.body.decoded
          @a[8] = @emails.body

          #
        #Mail.delete_all



        #end



      end


    end


  end





end
