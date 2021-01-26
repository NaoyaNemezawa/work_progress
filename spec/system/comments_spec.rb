require 'rails_helper'

RSpec.describe "コメント作成機能", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project)
    UserProject.create(user_id:@user.id, project_id:@project.id)
    Task.create(name: "テスト用タスク", specifics: nil, project_id:@project.id)
    @task = Task.find_by(project_id:@project.id)
  end
  context "新規コメント作成できるとき" do
    it "プロジェクトのメンバーはコメントを投稿できる" do
      # ログインしてコメント一覧を表示する
      sign_in(@user)
      click_on @project.name
      click_on @task.name
      find('div[data-target="#modal_c1"]').click
      # コメント作成画面の確認
      expect(page).to have_content "新しいコメントを追加します"
      # コメントを追加するとコメントテーブルのカウントが１上がる。
      fill_in "comment[comment]", with: "コメント作成テスト"
      expect{find_button("コメント追加").click}.to change{Comment.count}.by(1)
      # コメント一覧画面に新規作成したコメントが表示される
      expect(current_path).to eq project_task_comments_path(@project.id, @task.id)
      expect(page).to have_content "コメント作成テスト"
    end
  end
  context "コメント作成できないとき" do
    it "ログインしていないとコメント作成できない" do
      # ログインしていない状態でURLを直接入力するとログインページへ遷移する
      visit project_task_comments_path(@project.id, @task.id)
      expect(current_path).to eq new_user_session_path
    end
    it "招待されていないユーザーはコメントを作成できない" do
      user2 = FactoryBot.create(:user)
      sign_in(user2)
      # 招待されていないユーザーはプロジェクトのリンクが存在しない
      expect(page).to have_no_link @project.name
      pending "要対策。URLを直接入力するとインデックスへ遷移する"
      visit project_task_comments_path(@project.id, @task.id)
      expect(current_path).to eq root_path
    end
  end
end

RSpec.describe "コメント編集機能", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project)
    UserProject.create(user_id:@user.id, project_id:@project.id)
    Task.create(name: "テスト用タスク", specifics: nil, project_id:@project.id)
    @task = Task.find_by(project_id:@project.id)
    Comment.create(comment:"テスト用コメント",task_id:@task.id,user_id:@user.id)
    @comment = Comment.find_by(task_id:@task.id)
  end
  context "コメント編集できるとき" do
    it "コメントしたユーザーはコメントを編集できる" do
      # ログインしてコメント一覧を表示する
      sign_in(@user)
      click_on @project.name
      click_on @task.name
      # コメント作成画面の確認
      find_by_id("ce#{@comment.id}").click
      expect(page).to have_content "#{@comment.comment}を変更します"
      # コメントを編集してもコメントテーブルのカウントは変わらない。
      fill_in "comment[comment]", with: "テスト用コメントの編集"
      expect{find_button("編集する").click}.to change{Comment.count}.by(0)
      # コメント一覧画面に編集したしたコメントが表示される
      expect(current_path).to eq project_task_comments_path(@project.id, @task.id)
      expect(page).to have_content "テスト用コメントの編集"
    end
  end
  context "コメントの編集ができないとき" do
    it "ログインしていないとコメントの編集ができない" do
      # ログインしていない状態でURLを直接入力するとログインページへ遷移する
      visit project_task_comments_path(@project.id, @task.id)
      expect(current_path).to eq new_user_session_path
    end
    it "招待されていないユーザーはコメントを作成できない" do
      user2 = FactoryBot.create(:user)
      sign_in(user2)
      # 招待されていないユーザーはプロジェクトのリンクが存在しない
      expect(page).to have_no_link @project.name
      pending "要対策。URLを直接入力するとインデックスへ遷移する"
      visit project_task_comments_path(@project.id, @task.id)
      expect(current_path).to eq root_path
    end
    it "コメントを投稿したユーザー以外はコメントの編集ができない" do
      # メンバーの招待
      user2 = FactoryBot.create(:user)
      UserProject.create(user_id:user2.id,project_id:@project.id)
      # ログインしてコメント一覧を表示
      sign_in(user2)
      click_on @project.name
      click_on @task.name
      # コメント表示の確認
      expect(page).to have_content @comment.comment
      pending "要対策。編集ボタンの非表示"
      within "#comment#{@comment.id}" do
        expect(page).to have_no_content("編集")
      end
    end
  end
end
# binding.pry