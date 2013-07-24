class Admin::UsersController < ApplicationController

  before_filter :is_admin



  def index
    @users = Users.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @users }
    end
  end

  def show
    @users = Users.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @users }
    end
  end

  def user_edit
    @user_f = Users.find(params[:id])
    @users = Users.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @users }
    end
  end

  def user_new_ldap


    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def user_new
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @users }
    end
  end


  def srv_user_edit
    @user = Users.find(params[:inputId])
#    @user.login = params[:inputLogin]
    @user.f_name = params[:inputF]
    @user.i_name = params[:inputI]
    @user.o_name = params[:inputO]
    @user.email = params[:inputEmail]
    @user.ticket_email = params[:inputTicketEmail]
    @user.save
    render text: "srv_user_edit"
  end



  def srv_user_new

    @user = Users.find_or_initialize_by(login: params[:inputLogin])
    @user.login = params[:inputLogin]
    @user.f_name = params[:inputF]
    @user.i_name = params[:inputI]
    @user.o_name = params[:inputO]
    @user.password = pass_generate(8)
    @user.email = params[:inputEmail]
    @user.ticket_email = params[:inputTicketEmail]
    @user.save if @user.new_record?

    render text: "srv_user_new"
  end

  def srv_user_new_ldap
    params[:user].each { |value|
      parsed_json = ActiveSupport::JSON.decode(value[0])
      @user = Users.find_or_initialize_by(login: parsed_json["sAMAccountName"])
      @user.login = parsed_json["sAMAccountName"]
      @user.f_name = parsed_json["sn"]
      @user.i_name = parsed_json["givenName"]
      #@user.o_name = parsed_json["givenName"]
      @user.password = pass_generate(8)
      @user.email = parsed_json["mail"]
      @user.ticket_email = ""
      @user.save if @user.new_record?
    } if params[:user] != nil
    render text: "srv_user_new_ldap"
  end


  def srv_user_delete
    @user = Users.find_by_id(params[:user_id])
    @user.destroy
    render text: "srv_user_delete"
  end


  private
  def is_admin
    if !session[:is_admin]
      redirect_to "/"
    end
  end

end
