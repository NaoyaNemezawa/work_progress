require 'rails_helper'

RSpec.describe TasksController, type: :request do

  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project)
    @task = FactoryBot.create(:task)
    sign_in @user
  end

  describe "GET #index" do
    context "ログインしているとき" do
      it "indexアクションにリクエストすると正常にレスポンスが返ってくる" do
        get project_tasks_path(@project.id)
        expect(response.status).to eq 200
      end

      it "indexアクションにリクエストするとレスポンスにタスク名が含まれる" do
        @task2 = Task.create(name: "テスト",specifics: nil, project_id: @project.id)
        # 何故かテスト通らないので@task2として作成。余裕あれば原因調査
        get project_tasks_path(@project.id)
        expect(response.body).to include @task2.name
      end
    end

    context "ログアウト状態の場合" do
      it "ログアウト状態ではログインページにリダイレクトする" do
        sign_out @user
        get project_tasks_path(@project.id)
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  # showアクションからindexへ変更したため取り下げ。再度showアクションを設定した場合に使用できるのでコメントアウト。
  # describe "GET #show" do
    # context "ログインしているとき" do
    #   # it "showアクションにリクエストすると正常にレスポンスが返ってくる" do
    #     get project_task_path(@project.id,@task.id)
    #     expect(response.status).to eq 200
    #   end

      # it "showアクションにリクエストするとレスポンスにタスク名が含まれる" do
        # get project_task_path(@project.id,@task.id)
        # expect(response.body).to include @task.name
      # end

    #   it "showアクションにリクエストするとレスポンスにプロジェクト名が含まれる" do
    #     get project_task_path(@project.id,@task.id)
    #     expect(response.body).to include @project.name
    #   end
    # end

    # context "ログアウト状態の場合" do
    #   it "ログアウト状態ではログインページにリダイレクトする" do
    #     sign_out @user
    #     get project_task_path(@project.id,@task.id)
    #     expect(response).to redirect_to "/users/sign_in"
    # end
    # end
  # end

end
