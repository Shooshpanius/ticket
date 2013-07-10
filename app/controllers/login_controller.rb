class LoginController < ApplicationController




  def index

    if session[:is_login]
      redirect_to '/'
    end

  end



  def srv_check_login

    user = Users.find_by_login(params[:login])

    if user.nil? or user.password != params[:password]
      render text: "OK"

    else
      session[:is_admin] = true
      session[:is_login] = true
      render text: "OK2"
    end

  end


  def srv_logout
    reset_session
    render text: "OK2"
  end





end
