class Admin::UserEditController < ApplicationController
  before_filter :is_admin






  def show


  end





  private
  def is_admin
    if !session[:is_admin]
      redirect_to "/"
    end
  end

end
