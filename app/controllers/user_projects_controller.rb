class UserProjectsController < ApplicationController
  before_action :project_find
  def new
    @user_project = UserProject.new
  end

  def create
    # binding.pry
    @user_project = UserProject.new
    user = User.find_by(email: params[:email])
    @user_project[:project_id] = params[:project_id]
    unless user.nil?
      @user_project[:user_id] = user.id
      if @user_project.save
        redirect_to project_tasks_path(params[:project_id])
      else
        render :new
      end
    else
      render :new
    end
  end

  private
  def project_find
    @project = Project.find(params[:project_id])
  end
end
