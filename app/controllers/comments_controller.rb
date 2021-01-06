class CommentsController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:task_id])
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    binding.pry
    if @comment.save
      redirect_to root_path
    else
      render :index
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:comment).merge(user_id: current_user.id, task_id: params[:task_id])
  end
end
