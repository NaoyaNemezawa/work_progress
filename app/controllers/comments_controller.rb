class CommentsController < ApplicationController
  before_action :find_data
  before_action :new_data, only:[:indexm,:create]
  def index
    @comment = Comment.new
    @user_project = UserProject.new
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to index_comments
    else
      render :index
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to index_comments
  end

  private
  def comment_params
    params.require(:comment).permit(:comment).merge(user_id: current_user.id, task_id: params[:task_id])
  end

  def find_data
    @project = Project.find(params[:project_id])
    @tasks = @project.tasks
    @task = Task.find(params[:task_id])
    @comments = @task.comments.includes(:user)
  end

  def new_data
    @newproject = Project.new
    @newtask = Task.new
  end

  def index_comments
    project_task_comments_path(@project.id,@task.id)
  end
end
