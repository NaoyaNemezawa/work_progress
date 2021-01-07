class CommentsController < ApplicationController
  before_action :find_data
  def index
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to project_task_comments_path(@project.id,@task.id)
    else
      render :index
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to project_task_comments_path(@project.id,@task.id)
  end

  private
  def comment_params
    params.require(:comment).permit(:comment).merge(user_id: current_user.id, task_id: params[:task_id])
  end

  def find_data
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:task_id])
    @comments = @task.comments.includes(:user)
  end
end
