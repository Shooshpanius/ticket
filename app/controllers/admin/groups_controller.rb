class Admin::GroupsController < ApplicationController

  before_filter :is_admin

  def index
    @groups = Group.all
    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: @groups }
    end
  end


  def group_new
    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: @groups }
    end
  end


  def group_edit
    @group = Group.find(params[:id])
    @users = User.all
    @users_by_groups = UserByGroup.where( "group_id = ?", params[:id])
    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: @group }
    end
  end


  def srv_group_edit

    @group = Group.find(params[:inputId])
    @group.name = params[:inputName]
    @group.ticket_email = params[:inputTicketEmail]
    @group.ticket_email = params[:inputTicketEmailPassword]
    (params[:optionsLeader] != nil) ? @group.leader = params[:optionsLeader] : @group.leader = nil
    @group.save

    UserByGroup.delete_all(:group_id => params[:inputId] )

    params[:user].each_with_index { |(key, value), i|
      var_pr = /\d/
      @users_by_groups = UserByGroup.new()
      @users_by_groups.group_id = params[:inputId]
      @users_by_groups.user_id = key.scan(var_pr)[0]
      @users_by_groups.save
    } if params[:user] != nil


    render text: "srv_group_edit"
  end


  def srv_group_new
    @group = Group.new()
    @group.name = params[:inputName]
    @group.ticket_email = params[:inputTicketEmail]
    @group.ticket_email = params[:inputTicketEmailPassword]
    @group.save
    render text: "srv_group_new"
  end



  private
  def is_admin
    if !session[:is_admin]
      redirect_to "/"
    end
  end

end
