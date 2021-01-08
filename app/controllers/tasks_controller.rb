class TasksController < ApplicationController
  before_action :project_find, except:[:destroy]
  before_action :task_find, only:[:edit,:update,:destroy] 

  def index
    @tasks = @project.tasks
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to index_tasks
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to index_tasks
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to index_tasks
  end

  private
  def task_params
    params.require(:task).permit(:name,:specifics).merge(project_id: params[:project_id])
  end

  def project_find
    @project = Project.find(params[:project_id])
  end

  def task_find
    @task = Task.find(params[:id])
  end

  def index_tasks
    project_tasks_path(params[:project_id])
  end
end
