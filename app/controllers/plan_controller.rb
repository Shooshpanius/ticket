class PlanController < ApplicationController

  before_filter :is_login


  def index



  end


  private
  def is_login
    unless session[:is_login]
      redirect_to "/"
    end
  end


end
