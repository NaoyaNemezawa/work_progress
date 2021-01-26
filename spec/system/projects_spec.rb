require 'rails_helper'

RSpec.describe "プロジェクトの新規作成", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @project_name = "テスト用プロジェクト名"
  end
  context "プロジェクトの作成ができるとき" do
    it "ログインしたユーザーはプロジェクトの新規作成ができる" do
      # ログイン
      sign_in(@user)
      # 追加ボタンをクリックすると新規ブロジェクト作成ページが表示される
      find('div[data-target="#modal_p1"]').click
      expect(page).to have_content "新しいプロジェクトを立ち上げます"
      # 必要な情報を入力してプロジェクト作成を押すと、プロジェクトモデルのカウントが１上がることを確認する
      fill_in "project[name]", with: @project_name
      expect{find('input[name="commit"]').click}.to change{Project.count}.by(1)
      # トップページに遷移したことを確認する
      expect(current_path).to eq root_path
      # トップページに新規作成したプロジェクトのリンクがあることを確認する
      expect(page).to have_link @project_name
    end

    it "プロジェクト作成時に複数のユーザーを招待できる" do
      # 作成中に気づいたのが、これユーザープロジェクトの中間テーブルのシステムテストだ
      # テスト用ユーザーの作成
      user2 = FactoryBot.create(:user)
      # user3 = FactoryBot.create(:user)  2人以上まとめて招待できる処理をしたかったが、増やした入力欄の区別ができない
      # ログインして新規プロジェクト作成ページを表示、プロジェクト名を入力する
      sign_in(@user)
      find('div[data-target="#modal_p1"]').click
      fill_in "project[name]", with: @project_name
      # メンバー招待用のメール入力欄を増やす→増やしたはいいが入力欄の区別が親要素に依存しているためやり方を考える
      # find_by_id('add_btn').click
      # 招待したいユーザーのメールアドレスを入力する
      fill_in "project[emails][]", with: user2.email
      # プロジェクト作成ボタンを押すと、ユーザープロジェクトモデルのカウントが２上がることを確認する。
      expect{find('input[name="commit"]').click}.to change{UserProject.count}.by(2)
      # トップページに遷移したことを確認する
      expect(current_path).to eq root_path
      # トップページに新規作成したプロジェクトのリンクがあることを確認する
      expect(page).to have_link @project_name
      # 新規作成したプロジェクトのリンクをクリックすると招待したメンバーの名前が表示される
      click_on @project_name
      expect(page).to have_content user2.name
    end
  end

  context "プロジェクトの新規作成ができないとき" do
    it "ログインしていないとプロジェクトの作成ができない" do
      # トップページに移動しようとするとログインページへ遷移する
      visit root_path
      expect(current_path).to eq new_user_session_path
    end

    it "登録されていないemailを入力するとプロジェクトの新規作成ができない" do
      # ログインする
      sign_in(@user)
      # 新規プロジェクト作成欄を表示
      find('div[data-target="#modal_p1"]').click
      # プロジェクト名入力
      fill_in "project[name]", with: @project_name
      # 登録されていないemailを入力
      fill_in "project[emails][]", with: "test@example.com"
      # プロジェクト作成ボタンを押すと、プロジェクトモデルのカウントが変わらないことを確認する。
      expect{find('input[name="commit"]').click}.to change{Project.count}.by(0)
      # projectアクションのindexに遷移したことを確認する
      expect(current_path).to eq "/projects"
      # 登録しようとしたプロジェクト名のリンクがないことを確認する
      expect(page).to have_no_link @project_name
    end
  end
end

RSpec.describe "プロジェクトの編集", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project)
    # 中間テーブルを介して紐付け。もっと良い方法が見つかるまではベタ打ち
    UserProject.create(user_id:@user.id, project_id:@project.id)
  end
  context "プロジェクトの編集ができるとき" do
    it "プロジェクトを作成したユーザーはプロジェクトの編集ができる" do
      # ログインしてプロジェクト編集画面を確認
      sign_in(@user)
      click_on @project.name
      find('div[id="dropdownproject"]').click
      find('div[data-target="#modal_p2"]').click
      expect(page).to have_content "#{@project.name}を変更します"
      # 編集画面に既存のプロジェクト名が入力されていることの確認
      expect(find('input[name="project[name]"]').value).to eq @project.name
      # プロジェクト名を編集してもプロジェクトテーブルのカウントは増えない
      fill_in "project[name]", with: "テスト用プロジェクトを編集"
      expect{find('input[name="commit"]').click}.to change{Project.count}.by(0)
      # トップページに新しいプロジェクト名が表示される
      expect(current_path).to eq root_path
      expect(page).to have_content "テスト用プロジェクトを編集"
    end

    it "招待したメンバーはプロジェクトの編集ができる" do
      # 既存のプロジェクトへ紐付け
      user2 = FactoryBot.create(:user)
      UserProject.create(user_id:user2.id, project_id:@project.id)
      # ログインしてプロジェクト編集画面を確認
      sign_in(user2)
      click_on @project.name
      find('div[id="dropdownproject"]').click
      find('div[data-target="#modal_p2"]').click
      expect(page).to have_content "#{@project.name}を変更します"
      # 編集画面に既存のプロジェクト名が入力されていることの確認
      expect(find('input[name="project[name]"]').value).to eq @project.name
      # プロジェクト名を編集してもプロジェクトテーブルのカウントは増えない
      fill_in "project[name]", with: "テスト用プロジェクトを編集"
      expect{find('input[name="commit"]').click}.to change{Project.count}.by(0)
      # トップページに新しいプロジェクト名が表示される
      expect(current_path).to eq root_path
      expect(page).to have_content "テスト用プロジェクトを編集"
    end
  end
  context "プロジェクトの編集ができないとき" do
    it "招待されていないユーザーはプロジェクトの編集ができない" do
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

RSpec.describe "プロジェクトの削除", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project)
    # 中間テーブルを介して紐付け。もっと良い方法が見つかるまではベタ打ち
    UserProject.create(user_id:@user.id, project_id:@project.id)
  end
  context "プロジェクトを削除できるとき" do
    it "プロジェクト作成者はプロジェクトの削除ができる" do
      # サインインしてプロジェクト編集欄を表示する
      sign_in(@user)
      click_on @project.name
      find('div[id="dropdownproject"]').click
      find('div[data-target="#modal_p4"]').click
      # 削除前の確認表示
      expect(page).to have_content "#{@project.name}を削除します。"
      # 削除ボタンを押すとプロジェクトテーブルのカウントが１下がる
      expect{find_link("削除する").click}.to change{Project.count}.by(-1)
      # トップページに遷移し、プロジェクト一覧に表示されなくなる
      expect(current_path).to eq root_path
      expect(page).to have_no_link @project.name
    end
    it "メンバーはプロジェクトを削除できる" do
      # 紐付け
      user2 = FactoryBot.create(:user)
      UserProject.create(user_id:user2.id, project_id:@project.id)
      # ログインしてプロジェクト削除確認の表示
      sign_in(user2)
      click_on @project.name
      find('div[id="dropdownproject"]').click
      find('div[data-target="#modal_p4"]').click
      expect(page).to have_content "#{@project.name}を削除します。"
      # 削除ボタンを押すとプロジェクトテーブルのカウントが１下がる
      expect{find_link("削除する").click}.to change{Project.count}.by(-1)
      # トップページに遷移し、プロジェクト一覧に表示されなくなる
      expect(current_path).to eq root_path
      expect(page).to have_no_link @project.name
    end
  end

  context "プロジェクトを削除できないとき" do
    it "ログインしていないとプロジェクトの削除ができない" do
      # ログインせずにURLを直接入力するとログインページへ遷移する
      visit project_tasks_path(@project.id)
      expect(current_path).to eq new_user_session_path
    end
    it "招待されていないユーザーはプロジェクトの削除ができない" do
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