class UserProjectsController < ApplicationController
  before_action :project_find
  def new
    @user_project = UserProject.new
  end

  def create
    @user_project = UserProject.new
    user = User.find_by(email: params[:user_project][:email])
    @user_project[:user_id] = user.id
    @user_project[:project_id] = params[:project_id]
    if @user_project.save
      redirect_to root_path
    else
      render "new"
    end
  end

  private
  def project_find
    @project = Project.find(params[:project_id])
  end
end
