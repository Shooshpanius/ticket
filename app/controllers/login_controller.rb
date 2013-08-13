class LoginController < ApplicationController




  def index

    @ip = ip()

    if session[:is_login]
      redirect_to '/'
    end

  end



  def srv_check_login

    user = User.find_by_login(params[:login])

    if user.nil? or user.password != params[:password]

    else
      session[:is_login] = true
      session[:user_id] = user.id

      user.auth_last_ip = ip()
      user.save
    end

    if user.admin
      session[:is_admin] = true
    end

    render text: "srv_check_login"

  end


  def srv_logout
    reset_session
    render text: "srv_logout"
  end


  def ip()
    request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
  end


end
