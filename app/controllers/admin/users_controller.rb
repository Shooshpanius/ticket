class Admin::UsersController < ApplicationController

  before_filter :is_admin



  def index
  end

  def show

    @users = Users.all


    respond_to do |format|
      format.html {

        #@users.each do |user|
        #  render "/_menu"
        #
        #
        #end


      } # show.html.erb
      format.json { render json: @users }
    end


  end




  private
  def is_admin
    if !session[:is_admin]
      redirect_to "/"
    end
  end

end
