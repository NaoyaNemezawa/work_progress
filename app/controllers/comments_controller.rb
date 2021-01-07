class CommentsController < ApplicationController
  before_action :find
  def index
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to root_path
    else
      render :index
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to root_path
  end

  private
  def comment_params
    params.require(:comment).permit(:comment).merge(user_id: current_user.id, task_id: params[:task_id])
  end

  def find
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:task_id])
    @comments = @task.comments.includes(:user)
  end
end
