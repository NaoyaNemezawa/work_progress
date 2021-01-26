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
# binding.pry