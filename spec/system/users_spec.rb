require 'rails_helper'
# binding.pry 入力用
RSpec.describe "ユーザー新規登録", type: :system do
  before do
    @user=FactoryBot.build(:user)
  end
  context "ユーザー新規登録できるとき" do
    it "必要な情報を入力すれば新規登録できてトップページに移動する" do
      # トップページへ移動するとログインページへ遷移する
      visit root_path
      expect(current_path).to eq new_user_session_path
      # サインアップページへ移動するボタンが有ることを確認する
      expect(page).to have_content("まだアカウントをお持ちでない方")
      # サインアップページに移動する
      visit new_user_registration_path
      # 必要な情報を入力
      fill_in "user[name]", with: @user.name
      fill_in "user[email]", with: @user.email
      fill_in "user[password]", with: @user.password
      fill_in "user[password_confirmation]", with: @user.password_confirmation
      # サインアップボタンを押すと、ユーザーモデルのカウントが１上がることを確認する
      expect{find('input[name="commit"]').click}.to change{User.count}.by(1)
      # トップページに遷移する
      expect(current_path).to eq root_path
    end
  end

  context "ユーザー新規登録できないとき" do
    it "必要な情報がない場合、新規登録できずに新規登録ページへ戻ってくる" do
      # トップページへ移動するとログインページへ遷移する
      visit root_path
      expect(current_path).to eq new_user_session_path
      # サインアップページへ移動するボタンが有ることを確認する
      expect(page).to have_content("まだアカウントをお持ちでない方")
      # サインアップページに遷移する
      visit new_user_registration_path
      # 空のユーザー情報を入力する
      fill_in "user[name]", with: ""
      fill_in "user[email]", with: ""
      fill_in "user[password]", with: ""
      fill_in "user[password_confirmation]", with: ""
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect{find('input[name="commit"]').click}.to change{User.count}.by(0)
      # 新規登録ページに遷移することを確認する
      expect(current_path).to eq "/users"
    end
  end
end

RSpec.describe "ログイン機能", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context "ログインできるとき" do
    it "保存されているツーザーの情報と合致すればログインできる" do
      # ログインページに移動する
      visit root_path
      expect(current_path).to eq new_user_session_path
      # ユーザー情報を入力する
      fill_in "user[email]", with: @user.email
      fill_in "user[password]", with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移する
      expect(current_path).to eq root_path
      # トップページにログイン中のユーザー名が表示されている
      expect(page).to have_content(@user.name)
    end
  end
  context "ログインできないとき" do
    it "保存されているユーザーの情報と合致しない場合ログインできずログインページに戻る" do
    # ログインページに移動する
    visit root_path
    expect(current_path).to eq new_user_session_path
    # 空のユーザー情報を入力する
    fill_in "user[email]", with: ""
    fill_in "user[password]", with: ""
    # ログインボタンを押す
    find('input[name="commit"]').click
    # トップページに遷移せずログインページへ戻ってくる
    expect(current_path).to eq new_user_session_path
    end
  end
end