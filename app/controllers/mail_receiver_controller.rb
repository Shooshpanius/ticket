class MailReceiverController < ApplicationController

  require 'mail'

  def get_mail()

    users = User.all
    @a = ""
    @emails = Array.new(size=0, obj=nil)
    users.each_with_index do |user, i|
      if user.ticket_email != nil
        @emails[i] = user.ticket_email





      end


    end


  end





end
