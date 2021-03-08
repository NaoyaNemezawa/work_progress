class ProjectsController < ApplicationController

  def index
    @newproject = Project.new
  end

  def create
    flash.now[:error] = []
    params[:project][:emails].reject!(&:empty?)
    params[:project][:emails].each do |email|
      member = User.find_by(email: email)
      unless member.nil?
        params[:project][:user_ids] << member.id
      else
        flash.now[:error] << "#{email}は登録されていません"
      end
    end
    @project = Project.new(project_params)
    if flash.now[:error].empty? && @project.save
      redirect_to root_path
    else
      render :index
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to root_path
    else
      render :index
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to root_path
  end

  private

  def project_params
    params.require(:project).permit(:name, :deadline, user_ids: [])
  end
end
