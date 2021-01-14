class ProjectsController < ApplicationController
  before_action :signed_in?
  def index
    @newproject = Project.new
  end

  def new
    @project = Project.new
  end

  def create
    binding.pry
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

  def signed_in?
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
