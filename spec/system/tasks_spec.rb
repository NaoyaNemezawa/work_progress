require 'rails_helper'

RSpec.describe "タスクの作成", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project)
    UserProject.create(user_id:@user.id, project_id:@project.id)
    @task = FactoryBot.build(:task)
  end
  context "タスクの作成ができるとき" do
    it "プロジェクトのメンバーはタスクを作成できる" do
      # ログインしてタスク一覧を表示
      sign_in(@user)
      click_on @project.name
      # タスク作成画面の表示を確認する
      find('span[data-target="#modal_t1"]').click
      expect(page).to have_content "新しいタスクを作成します"
      # 必要な情報を入力
      fill_in "task[name]", with: @task.name
      fill_in "task[specifics]", with: @task.specifics
      # タスク作成ボタンを押すとタスクモデルのカウントが１上がる。
      expect{find_button("タスク作成").click}.to change{Task.count}.by(1)
      # タスク一覧ページに遷移したことの確認
      expect(current_path).to eq project_tasks_path(@project.id)
      # タスク一覧に新規作成したタスクがあることを確認
      expect(page).to have_link @task.name
      # コメント一覧画面にタスクの詳細が表示されている
      click_on @task.name
      expect(page).to have_content @task.specifics
    end
  end
  context "タスクを作成できないとき" do
    it "ログインしていないとタスクを作成できない" do
      # ログインせずにURLを直接入力するとログインページへ遷移する
      visit project_tasks_path(@project.id)
      expect(current_path).to eq new_user_session_path
    end
    it "プロジェクトメンバー以外のユーザーはタスクを作成できない" do
      user2 = FactoryBot.create(:user)
      sign_in(user2)
      # 招待されていないユーザーはプロジェクトのリンクが存在しない
      expect(page).to have_no_link @project.name
      pending "要対策。URLを直接入力するとインデックスへ遷移する"
      visit project_tasks_path(@project.id)
      expect(current_path).to eq root_path
    end
  end
end

RSpec.describe "タスクの編集", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project)
    UserProject.create(user_id:@user.id, project_id:@project.id)
    Task.create(name:"テスト用タスク",specifics:"テスト用タスク詳細",project_id:@project.id)
    @task = Task.find_by(project_id:@project.id)
  end
  context "タスクの編集ができるとき" do
    it "プロジェクトのメンバーはタスクの編集ができる" do
      # ログインしてコメント一覧画面を表示
      sign_in(@user)
      click_on @project.name
      click_on @task.name
      # タスク編集画面の表示を確認する
      find('div[id="dropdowntask"]').click
      find('div[data-target="#modal_t2"]').click
      expect(page).to have_content "#{@task.name}を変更します"
      # 編集画面に既存のタスク名とタスク詳細が入力されていることの確認
      expect(find('input[name="task[name]"]').value).to eq @task.name
      expect(find('textarea[name="task[specifics]"]').value).to eq @task.specifics
      # タスクを編集してもプロジェクトテーブルのカウントは増えない
      fill_in "task[name]", with: "テスト用タスクを編集"
      fill_in "task[specifics]", with: "テスト用タスク詳細を編集"
      expect{find_button("編集する").click}.to change{Task.count}.by(0)
      # タスク一覧に新しいタスク名が表示される
      expect(current_path).to eq project_tasks_path(@project.id)
      expect(page).to have_content "テスト用タスクを編集"
      # コメント一覧画面に新しいタスクの詳細が表示されている
      click_on @task.name
      expect(page).to have_content "テスト用タスク詳細を編集"
    end
  end
  context "タスクの編集ができないとき" do
    it "ログインしていないとタスクを編集できない" do
      # ログインせずにURLを直接入力するとログインページへ遷移する
      visit project_tasks_path(@project.id)
      expect(current_path).to eq new_user_session_path
    end
    it "プロジェクトメンバー以外のユーザーはタスクを編集できない" do
      user2 = FactoryBot.create(:user)
      sign_in(user2)
      # 招待されていないユーザーはプロジェクトのリンクが存在しない
      expect(page).to have_no_link @project.name
      pending "要対策。URLを直接入力するとインデックスへ遷移する"
      visit project_tasks_path(@project.id)
      expect(current_path).to eq root_path
    end
  end
end

RSpec.describe "タスクの削除", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project)
    UserProject.create(user_id:@user.id, project_id:@project.id)
    Task.create(name:"テスト用タスク",specifics:"テスト用タスク詳細",project_id:@project.id)
    @task = Task.find_by(project_id:@project.id)
  end
  context "タスクの削除ができるとき" do
    it "プロジェクトのメンバーはタスクの削除ができる" do
      # ログインしてコメント一覧画面を表示
      sign_in(@user)
      click_on @project.name
      click_on @task.name
      # タスク編集削除画面の表示を確認する
      find('div[id="dropdowntask"]').click
      find('div[data-target="#modal_t4"]').click
      expect(page).to have_content "#{@task.name}を削除します"
      # タスクを削除するとプロジェクトテーブルのカウントが１減る
      expect{find_link("削除する").click}.to change{Task.count}.by(-1)
      # タスク一覧に削除したタスク名がされない
      expect(current_path).to eq project_tasks_path(@project.id)
      expect(page).to have_no_link "テスト用タスクを編集"
    end
  end
  context "タスクの削除ができないとき" do
    it "ログインしていないとタスクを削除ができない" do
      # ログインせずにURLを直接入力するとログインページへ遷移する
      visit project_tasks_path(@project.id)
      expect(current_path).to eq new_user_session_path
    end
    it "プロジェクトメンバー以外のユーザーはタスクを削除できない" do
      user2 = FactoryBot.create(:user)
      sign_in(user2)
      # 招待されていないユーザーはプロジェクトのリンクが存在しない
      expect(page).to have_no_link @project.name
      pending "要対策。URLを直接入力するとインデックスへ遷移する"
      visit project_tasks_path(@project.id)
      expect(current_path).to eq root_path
    end
  end
end