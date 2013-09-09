class LoginController < ApplicationController

  require 'digest/md5'


  def index

    @ip = ip()

    user = User.where("auth_hash = ? and auth_last_ip = ?", cookies[:hash], ip() ).take(1)
    if user.size == 1
      session[:is_login] = true
      session[:user_id] = user[0].id
      session[:user_login] = user[0].login
      session[:is_admin] = true if user[0].admin
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
      session[:user_login] = user.login

      salt = pass_generate(len=7)
      hash = Digest::MD5.hexdigest(Time.now.to_s + salt.to_s)

      user.auth_hash = hash
      user.auth_last_ip = ip()
      user.save

      cookies[:hash] = { value: hash, expires: 10000.hour.from_now }

    end

    if user.admin
      session[:is_admin] = true
    end

    render :nothing => true

  end


  def srv_logout
    reset_session
    cookies.delete :hash
    render :nothing => true
  end


  def ip()
    request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
  end


end
