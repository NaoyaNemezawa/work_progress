class UserProjectsController < ApplicationController
  before_action :find_data

  def create
    @user_project = UserProject.new
    user = User.find_by(email: params[:user_project][:email])
    @user_project[:project_id] = params[:project_id]
    unless user.nil?
      @user_project[:user_id] = user.id
      if @user_project.save
        redirect_to project_tasks_path(params[:project_id])
      else
        render "tasks/index"
      end
    else
      render "tasks/index"
    end
  end

  private
  def find_data
    @project = Project.find(params[:project_id])
    @tasks = @project.tasks
    @newproject = Project.new
  end
end
