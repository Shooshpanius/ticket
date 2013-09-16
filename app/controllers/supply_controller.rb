# encoding: utf-8
class SupplyController < ApplicationController

  protect_from_forgery
  before_filter :is_login




  def in

    @form_data = {

    }

  end


  def out

    @form_data = {

    }

  end


  def supply_new

    @form_data = {

    }

  end

  private
  def is_login
    if !session[:is_login]
      redirect_to "/"
    end
  end

end
