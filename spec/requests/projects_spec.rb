require 'rails_helper'

RSpec.describe ProjectsController, type: :request do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project)
    sign_in @user
  end
  describe "GET #index" do
    context "ログインしているとき" do
      it "indexアクションにリクエストすると正常にレスポンスが返ってくる" do
        get root_path
        expect(response.status).to eq 200
      end

      it "indexアクションにリクエストするとレスポンスに作成済みのプロジェクト名が帰ってくる" do
        get root_path
        expect(response.body).to include @project.name
      end
    end

    context "ログインしていないとき" do
      it "ログアウト状態ではログインページにリダイレクトする" do
        sign_out @user
        get root_path
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "GET #show" do
    context "ログインしているとき" do
      it "showアクションにリクエストすると正常にレスポンスが返ってくる" do
        get project_path(@project)
        expect(response.status).to eq 200
      end

      it "showアクションにリクエストするとレスポンスにプロジェクト名が含まれる" do
        get project_path(@project)
        expect(response.body).to include @project.name
      end
    end

    context "ログインしていないとき" do
      it "ログアウト状態ではログインページにリダイレクトする" do
        sign_out @user
        get project_path(@project)
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
