require 'rails_helper'

RSpec.describe CommentsController, type: :request do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project)
    UserProject.create(user_id:@user.id, project_id:@project.id)
    Task.create(name: "テスト用タスク", specifics: nil, project_id:@project.id)
    @task = Task.find_by(project_id:@project.id)
    Comment.create(comment: "テスト用コメント", task_id: @task.id, user_id: @user.id)
    @comment = Comment.find_by(user_id: @user.id)
    sign_in @user
  end

  describe "GET #index" do
    context "ログインしているとき" do
      it "indexアクションにリクエストすると正常にレスポンスが返ってくる" do
        get project_task_comments_path(@project.id,@task.id)
        expect(response.status).to eq 200
      end
  
      it "indexアクションにリクエストするとレスポンスにコメントが含まれる" do
        get project_task_comments_path(@project.id,@task.id)
        expect(response.body).to include @comment.comment
      end
    end
  
    context "ログアウト状態の場合" do
      it "ログアウト状態ではログインページにリダイレクトする" do
        sign_out @user
        get project_task_comments_path(@project.id,@task.id)
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
