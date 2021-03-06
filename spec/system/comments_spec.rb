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
      image_path = Rails.root.join('public/images/test1.jpg')
      attach_file('comment[img]', image_path)
      expect{find_button("コメント追加").click}.to change{Comment.count}.by(1)
      # コメント一覧画面に新規作成したコメントが表示される
      expect(current_path).to eq project_task_comments_path(@project.id, @task.id)
      expect(page).to have_content "コメント作成テスト"
      # コメント一覧に登楼した画像が表示される
      expect(page).to have_selector("img[src$='test1.jpg']")
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
      # 招待されていないユーザーがURLを直接入力するとトップページへ遷移する
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
    Comment.create(comment:"テスト用コメント",task_id:@task.id,user_id:@user.id, img: Rack::Test::UploadedFile.new(Rails.root.join("public/images/test1.jpg")))
    @comment = Comment.find_by(task_id:@task.id)
  end
  context "コメント編集できるとき" do
    it "コメントしたユーザーはコメントを編集できる" do
      # ログインしてコメント一覧を表示する
      sign_in(@user)
      click_on @project.name
      click_on @task.name
      # コメント編集画面の確認
      find_by_id("ce#{@comment.id}").click
      expect(page).to have_content "コメントの内容を変更します"
      expect(page).to have_selector("img[src$='test1.jpg']")
      # コメントを編集してもコメントテーブルのカウントは変わらない。
      fill_in "comment[comment]", with: "テスト用コメントの編集"
      image_path = Rails.root.join('public/images/test2.jpg')
      attach_file('comment[img]', image_path)
      expect{find_button("編集する").click}.to change{Comment.count}.by(0)
      # コメント一覧画面に編集したしたコメントが表示される
      expect(current_path).to eq project_task_comments_path(@project.id, @task.id)
      expect(page).to have_content "テスト用コメントの編集"
      # 変更した画像が表示される
      expect(page).to have_selector("img[src$='test2.jpg']")
      # 編集後の画像が表示される。
    end
  end
  context "コメントの編集ができないとき" do
    it "ログインしていないとコメントの編集ができない" do
      # ログインしていない状態でURLを直接入力するとログインページへ遷移する
      visit project_task_comments_path(@project.id, @task.id)
      expect(current_path).to eq new_user_session_path
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
      # コメントを投稿したユーザー以外は編集ボタンが表示されないことの確認
      within "#comment#{@comment.id}" do
        expect(page).to have_no_content("編集")
      end
    end
  end
end

RSpec.describe "コメント削除機能", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project)
    UserProject.create(user_id:@user.id, project_id:@project.id)
    Task.create(name: "テスト用タスク", specifics: nil, project_id:@project.id)
    @task = Task.find_by(project_id:@project.id)
    Comment.create(comment:"テスト用コメント",task_id:@task.id,user_id:@user.id, img: Rack::Test::UploadedFile.new(Rails.root.join("public/images/test1.jpg")))
    @comment = Comment.find_by(task_id:@task.id)
  end
  context "コメント削除できるとき" do
    it "コメントしたユーザーはコメントを削除できる" do
      # ログインしてコメント一覧を表示する
      sign_in(@user)
      click_on @project.name
      click_on @task.name
      # コメント画面の確認
      find_by_id("cd#{@comment.id}").click
      expect(page).to have_content "コメントを削除します"
      # コメントを削除するとコメントテーブルのカウントが１下がる。
      expect{find_link("削除").click}.to change{Comment.count}.by(-1)
      # コメント一覧画面に削除したコメントが表示されない
      expect(current_path).to eq project_task_comments_path(@project.id, @task.id)
      expect(page).to have_no_content "テスト用コメントの編集"
      expect(page).to have_no_selector("img[src$='test1.jpg']")
    end
  end
  context "コメントの削除ができないとき" do
    it "ログインしていないとコメントの編集ができない" do
      # ログインしていない状態でURLを直接入力するとログインページへ遷移する
      visit project_task_comments_path(@project.id, @task.id)
      expect(current_path).to eq new_user_session_path
    end
    it "コメントを投稿したユーザー以外はコメントの削除ができない" do
      # メンバーの招待
      user2 = FactoryBot.create(:user)
      UserProject.create(user_id:user2.id,project_id:@project.id)
      # ログインしてコメント一覧を表示
      sign_in(user2)
      click_on @project.name
      click_on @task.name
      # コメント表示の確認
      expect(page).to have_content @comment.comment
      expect(page).to have_selector("img[src$='test1.jpg']")
      # コメントを投稿したユーザーでない場合、削除ボタンが表示されないことの確認
      within "#comment#{@comment.id}" do
        expect(page).to have_no_content("削除")
      end
    end
  end
end