class ProjectsController < ApplicationController
  before_action :signed_in?
  def index
  end

  def new
    @project = Project.new
  end

  def create
    if params[:project][:member_name]
      member = User.find_by(name: params[:project][:member_name])
      params[:project][:user_ids] << member.id
    end
    @project = Project.new(project_params)
    if @project.save
      redirect_to root_path
    else
      render "new"
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  private

  def signed_in?
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end

  def project_params
    params.require(:project).permit(:name, user_ids: [])
  end
end
