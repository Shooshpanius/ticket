class LoginController < ApplicationController

  require 'digest/md5'


  def index

    @ip = ip()

    user = User.where("auth_hash = ? and auth_last_ip = ?", cookies[:hash], ip() ).take(1)
    if user.size == 1
      session[:is_login] = true
      session[:user_id] = user.id
      session[:is_admin] = true if user.admin
    end

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

      salt = pass_generate(len=7)
      hash = Digest::MD5.hexdigest(Time.now.to_s + salt.to_s)

      user.auth_hash = hash
      user.auth_last_ip = ip()
      user.save

      cookies[:hash] = { value: hash, expires: 10.hour.from_now }

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
