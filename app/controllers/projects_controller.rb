class ProjectsController < ApplicationController
  before_action :signed_in?
  def index
  end

  def new
    @project = Project.new
    @member_email = nil
  end

  def create
    flash[:error] = []
    params[:project][:emails].each do |email|
      unless email.empty?
        member = User.find_by(email: email)
        unless member.nil?
          params[:project][:user_ids] << member.id
        else
          flash[:error]<<"#{email}は存在しません"
        end
      end
    end
    @project = Project.new(project_params)
    if flash[:error].empty? && @project.save
      redirect_to root_path
    else
      render :new
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
