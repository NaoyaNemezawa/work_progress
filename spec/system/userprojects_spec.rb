require 'rails_helper'

RSpec.describe "プロジェクトへユーザーの追加招待", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project)
    # 中間テーブルの紐付け、他に方法あれば対応する
    UserProject.create(user_id:@user.id, project_id:@project.id)
    # 招待されるユーザーデータ
    @user2 = FactoryBot.create(:user)
  end
  context "プロジェクトにユーザーの招待ができるとき" do
    it "プロジェクト作成時に複数のユーザーを招待できる" do
      # user3 = FactoryBot.create(:user)  2人以上まとめて招待できる処理をしたかったが、増やした入力欄の区別ができない
      # ログインして新規プロジェクト作成ページを表示、プロジェクト名を入力する
      sign_in(@user)
      find('div[data-target="#modal_p1"]').click
      fill_in "project[name]", with: "ユーザー招待機能テスト"
      # メンバー招待用のメール入力欄を増やす→増やしたはいいが入力欄の区別が親要素に依存しているためやり方を考える
      # find_by_id('add_btn').click
      # 招待したいユーザーのメールアドレスを入力する
      fill_in "project[emails][]", with: @user2.email
      # プロジェクト作成ボタンを押すと、ユーザープロジェクトモデルのカウントが２上がることを確認する。
      expect{find('input[name="commit"]').click}.to change{UserProject.count}.by(2)
      # トップページに遷移したことを確認する
      expect(current_path).to eq root_path
      # トップページに新規作成したプロジェクトのリンクがあることを確認する
      expect(page).to have_link "ユーザー招待機能テスト"
      # 新規作成したプロジェクトのリンクをクリックすると招待したメンバーの名前が表示される
      click_on "ユーザー招待機能テスト"
      expect(page).to have_content @user2.name
    end
    it "作成済みのプロジェクトへユーザーを招待できる" do
      # サインインしてメンバー招待欄を表示する
      sign_in(@user)
      click_on @project.name
      find('div[id="dropdownproject"]').click
      find('div[data-target="#modal_p3"]').click
      # メンバー招待欄の確認
      expect(page).to have_content "#{@project.name}のメンバーを追加します。"
      # 追加したいメンバーの情報を入力
      fill_in "user_project[email]", with: @user2.email
      # 招待ボタンを押すとUserProjectテーブルのカウントが１上がる
      expect{find_button('招待').click}.to change{UserProject.count}.by(1)
      # タスク一覧ページに遷移したことを確認する
      expect(current_path).to eq project_tasks_path(@project.id)
      # ページ内に招待したユーザーが存在することを確認する
      expect(page).to have_content @user2.name
    end
  end
  context "プロジェクトにユーザーを招待できないとき" do
    it "すでに招待済みのユーザーは招待できない" do
      # 招待済みのユーザー作成
      UserProject.create(user_id:@user2.id,project_id:@project.id)
      # サインインしてタスク一覧欄を表示する
      sign_in(@user)
      click_on @project.name
      # ページ内に招待したユーザーが存在することを確認する
      expect(page).to have_content @user2.name
      # メンバー招待欄を表示する
      find('div[id="dropdownproject"]').click
      find('div[data-target="#modal_p3"]').click
      # メンバー招待欄の確認
      expect(page).to have_content "#{@project.name}のメンバーを追加します。"
      # 追加したいメンバーの情報を入力
      fill_in "user_project[email]", with: @user2.email
      # 招待ボタンを押すとUserProjectテーブルのカウントは上がらない
      expect{find_button('招待').click}.to change{UserProject.count}.by(0)
      # タスク一覧ページに遷移したことを確認する
      expect(current_path).to eq "/projects/#{@project.id}/user_projects"
    end
  end
end
# binding.pry