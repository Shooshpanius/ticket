class Admin::UsersController < ApplicationController

  before_filter :is_admin



  def index
    @users = Users.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @users }
    end
  end

  #def show
  #
  #  @users = Users.all
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @users }
  #  end
  #
  #end




  private
  def is_admin
    if !session[:is_admin]
      redirect_to "/"
    end
  end

end
