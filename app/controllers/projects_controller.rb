class ProjectsController < ApplicationController
  before_action :signed_in?
  def index
    
  end

  def new
    @project = Project.new
  end

  def create
    binding.pry
    # @project = Project.new(project_params)
    # @project.save
    redirect_to root_path
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
