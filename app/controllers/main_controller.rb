class MainController < ApplicationController

  def index

    if session[:is_login]
      #redirect_to '/'
    else
      redirect_to '/login'
    end

  end


end
