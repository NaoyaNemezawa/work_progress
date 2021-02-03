## アプリ名
work_progress

## 概要
チームで行っている作業の進捗状況を共有し、管理を用意にするアプリケーションです。
このアプリではプロジェクト（目標）に対して複数のタスクを作成し、それぞれのタスクに各々のユーザーが進捗状況をコメントすることができます。
例えば新商品Aの販売するプロジェクトを建てた場合、新商品Aを開発すること、新商品Aを製造ラインに乗せること、新商品Aの販売経路を確保することの３つのタスクに分けることができるとします。
上記３つのタスクは対応する部署が異なる可能性が高いと考えられますが、各部署が連携して動く必要があります。本アプリではプロジェクトに参加しているメンバーは各部署の進捗コメントを共有できるため、進捗管理を容易にする事ができます。

## このアプリで目指した課題解決
前職では情報の共有方法がメールに頼っている状態だったため、以下のような問題点がありました。
- 重要な情報が他のメールに埋もれてしまう。
- メールの宛先に漏れがあると必要な人に情報が届かない。
- どのプロジェクトに関する情報であるかを、メール受信者側が各々管理する必要がある。
- １年以上かけるような長期プロジェクトで、空白期間があると忘れ去られる。
- 後からプロジェクトに参加した人が、参加時点での経過状況や流れを把握しにくい。

以上のような問題点を解決するに当たり、タスク管理ツールのようなものがあればよいのではないかと考えた次第です。

#### なんでwebアプリケーション？
webアプリケーションとパッケージソフトを比較した場合、webアプリケーションには次のようなメリットが有ると考えています。
- pcからスマホ、会社用pcから自宅pc等、デバイスが変わっても使用できる。
- インストール等が不要のため、開始するためのハードルが低い。
様々な企業においてリモートワークを導入してほしいと願う自分としてはwebアプリが良いと感じました。<br>
  ~~学んでいたのがRuby on Railsだったから、というのはあります。~~

## 洗い出した要件
- ユーザー管理機能
- タスク管理機能
- 情報表示範囲の制限機能

## 実装した機能について
- ユーザー招待機能について
  設定したプロジェクトに他の登録済みユーザーを招待し情報を共有することができます。
![readme用動画１](https://user-images.githubusercontent.com/71652340/106718192-0e615080-6644-11eb-8f19-c65cf2434e83.gif)

  なお招待されていないユーザーには情報は公開されず、情報を秘匿することができます。
<img width="900" alt="readme用１" src="https://user-images.githubusercontent.com/71652340/106716107-5b8ff300-6641-11eb-8f56-1c8ccbdd0e24.png">


## URL
http://www.workprogres.net/

### テスト用アカウント
- プロジェクト・タスク作成。メンバー招待用アカウント
  <br>email:test1@test
  <br>password:test111
- プロジェクト被招待・コメント投稿確認用アカウント
  <br>email:test2@test 
  <br>password:test222
  <br>＊権限付与機能は実装していないためどちらのアカウントを使用しても同じことができます。

### アプリの利用方法
テスト用アカウントでログインした後、プロジェクトを追加します。プロジェクト内にタスクを設定した後、タスク内にコメントを投稿できます。プロジェクトには登録済みの別ユーザーの招待することで情報の共有を行えます。招待するにはプロジェクト作成画面かユーザー招待画面において、
招待したいユーザーのメールアドレスを入力する必要があります。

## DB設計図
## Usersテーブル

| Column             | Type   | Options                  |
| ------------------ | ------ | ------------------------ |
| name               | string | null: false              |
| email              | string | null: false, unique:true |
| encrypted_password | string | null: false              |

### Association
- has_many :users_projects
- has_many :projects through: :users_projects
- has_many :comments

## Projectsテーブル

| Column             | Type   | Options                  |
| ------------------ | ------ | ------------------------ |
| name               | string | null: false              |

### Association
- has_many: users_projects
- has_many: users through: :users_projects
- has_many: tasks

## UsersProjectsテーブル
| Column             | Type      | Options                        |
| ------------------ | --------- | ------------------------------ |
| user_id            | reference | null: false, foreign_key: true |
| project_id         | reference | null: false, foreign_key: true |

### Association
- belongs_to: user
- belongs_to: project

## Tasksテーブル

| Column             | Type      | Options                        |
| ------------------ | --------- | ------------------------------ |
| name               | string    | null: false                    |
| specifics          | text      | none                           |
| project_id         | reference | null: false, foreign_key: true |

### Association
- belongs_to: project
- has_many: comments

## Commentsテーブル

| Column             | Type      | Options                        |
| ------------------ | --------- | ------------------------------ |
| comment            | text      | null: false                    |
| user_id            | reference | null: false ,foreign_key: true |
| task_id            | reference | null: false ,foreign_key: true |

### Association
- belongs_to: task
- belongs_to: user

# 今後追加して実装したい機能
- レスポンシブデザインの実装。
- ユーザーに権限機能を持たせて目標・タスクの編集機能の制限
- タスク進捗状況をゲージバーで表示する。
- タスクの期日を設定、表示する機能。
- 目標・タスク・コメント機能の非同期通信化
- 画像投稿機能の実装。また、編集時に画像をプレビューで表示させる。
- コメントに返信する機能。
- コメントにハイパーリンクを添付できる。