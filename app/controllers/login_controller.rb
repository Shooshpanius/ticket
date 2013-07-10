class LoginController < ApplicationController

  def index

    if session[:is_login]
      redirect_to '/admin/skills/list'
    end

  end


end
