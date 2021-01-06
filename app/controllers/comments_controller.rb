class CommentsController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:task_id])
  end
end
