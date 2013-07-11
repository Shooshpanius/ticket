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


  def srv_user_edit
    render text: "OK2"
  end




  private
  def is_admin
    if !session[:is_admin]
      redirect_to "/"
    end
  end

end
