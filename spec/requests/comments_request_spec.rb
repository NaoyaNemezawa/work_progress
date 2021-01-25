require 'rails_helper'

RSpec.describe CommentsController, type: :request do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project)
    @task = FactoryBot.create(:task)
    @comment = FactoryBot.create(:comment)
    sign_in @user
  end

  describe "GET #index" do
    context "ログインしているとき" do
      it "indexアクションにリクエストすると正常にレスポンスが返ってくる" do
        get project_task_comments_path(@project.id,@task.id)
        expect(response.status).to eq 200
      end
  
      it "indexアクションにリクエストするとレスポンスにコメントが含まれる" do
        @comment2 = Comment.create(comment: "テスト", task_id: @task.id, user_id: @user.id)
        # 処理の順番が１，ユーザー登録と同時にプロジェクト作成。２，プロジェクト作成。３，タスクなど作成のためかうまくパスしない
        # 対応策が見つかるまでは@comment2として作成。
        get project_task_comments_path(@project.id,@task.id)
        expect(response.body).to include @comment2.comment
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
