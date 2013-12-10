class ReportsController < ApplicationController

  before_filter :is_login


  def activity




  end





  private
  def is_login
    unless session[:is_login]
      redirect_to "/"
    end
  end

end
