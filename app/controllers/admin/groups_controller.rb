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
      @group = Groups.find(params[:id])
    @users = Users.all
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end


  def srv_group_edit

    @group = Groups.find(params[:inputId])
    @group.name = params[:inputName]
    @group.ticket_email = params[:inputTicketEmail]
    @group.save

    @users_by_groups = UsersByGroups.find_by groups_id: params[:inputId]
    if @users_by_groups != nil
      @users_by_groups.destroy
    end

    @a=[params[:user].size]
    params[:user].each_with_index{|(key,value), i|
      var_pr = /\d/
      @users_by_groups = UsersByGroups.new()
      @users_by_groups.groups_id = params[:inputId]
      @users_by_groups.users_id = key.scan(var_pr)[0]
      @users_by_groups.save
    }

    render text: @users_by_groups
  end


  def srv_group_new
    @group = Groups.new()
    @group.name = params[:inputName]
    @group.ticket_email = params[:inputTicketEmail]
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
