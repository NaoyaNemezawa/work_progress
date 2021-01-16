class TasksController < ApplicationController
  before_action :find_data, only:[:index,:create]

  def index
    @user_project = UserProject.new
    @newtask = Task.new
  end

  def create
    @newtask = Task.new(task_params)
    if @newtask.save
      redirect_to index_tasks
    else
      render :index
    end
  end

  # def update
  #   if @task.update(task_params)
  #     redirect_to index_tasks
  #   else
  #     render :edit
  #   end
  # end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to index_tasks
  end

  private
  def task_params
    params.require(:task).permit(:name,:specifics).merge(project_id: params[:project_id])
  end

  def find_data
    @project = Project.find(params[:project_id])
    @tasks = @project.tasks
    @newproject = Project.new
  end

  def index_tasks
    project_tasks_path(params[:project_id])
  end
end
