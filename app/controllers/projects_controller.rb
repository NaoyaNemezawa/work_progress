class ProjectsController < ApplicationController
  before_action :project_find, only:[:show, :destroy]
  def index
    @newproject = Project.new
  end

  def new
    @project = Project.new
  end

  def create
    flash[:error] = []
    params[:project][:emails].reject!(&:empty?)
    params[:project][:emails].each do |email|
      member = User.find_by(email: email)
      unless member.nil?
        params[:project][:user_ids] << member.id
      else
        flash[:error] << "#{email}は存在しません"
      end
    end
    @project = Project.new(project_params)
    if flash[:error].empty? && @project.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    @project.destroy
    redirect_to root_path
  end

  private

  def project_find
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, user_ids: [])
  end
end
