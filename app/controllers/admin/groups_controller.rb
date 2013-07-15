class Admin::GroupsController < ApplicationController

  before_filter :is_admin

  def index
    @groups = Groups.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @users }
    end
  end



  def group_new

    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: @groups }
    end
  end

  def group_edit
    @groups = Groups.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @groups }
    end
  end


  def srv_group_edit

    @group = Groups.find(params[:inputId])
    @group.name = params[:inputName]
    @group.ticket_email = params[:inputTicketEmail]
    @group.save

    @users_by_groups.where("orders_count = ? AND locked = ?", params[:orders], false)

    @a=[params[:user].size]
    params[:user].each_with_index{|(key,value), i|
      var_pr = /\d/
      @a[i] = key.scan(var_pr)[0]
    }

    render text: @a
  end





  private
  def is_admin
    if !session[:is_admin]
      redirect_to "/"
    end
  end

end
