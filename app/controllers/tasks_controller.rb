class TasksController < ApplicationController
  before_action :project_find
  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to project_path(params[:project_id])
    else
      render :new
    end
  end

  def show
    
  end

  private
  def task_params
    params.require(:task).permit(:name,:specifilcs).merge(project_id: params[:project_id])
  end

  def project_find
    @project = Project.find(params[:project_id])
  end
end
