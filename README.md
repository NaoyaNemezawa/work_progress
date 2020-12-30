# 現在鋭意製作中　紹介文も並行して記述してます。

# アプリ名
work_progress

# 概要
チームで行っている作業の進捗状況を共有し、管理を用意にするアプリケーションです。
このアプリでは特定の目標に対して複数のタスクを作成し、それぞれのタスクに各々のユーザーが進捗状況をコメントすることができます。
例えば新商品Aの販売を目標とした場合、新商品Aを開発すること、新商品Aを製造ラインに乗せること、新商品Aの販売経路を確保することの３つのタスクに分けることができるとします。
上記３つのタスクは対応する部署が異なる可能性が高いと考えられますが、各部署が連携して動く必要があります。本アプリではプロジェクトに参加しているメンバーは各部署の進捗状況を共有できるため、進捗管理を容易にする事ができます。

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
様々な企業においてリモートワークを導入してほしいと願う自分としてはwebアプリが良いと感じました。
~~学んでいたのがRuby on Railsだったから、というのはあります。~~

# DB設計図
## Usersテーブル

| Column             | Type   | Options                  |
| ------------------ | ------ | ------------------------ |
| name               | string | null: false              |
| email              | string | null: false, unique:true |
| encrypted_password | string | null: false              |

### Association
- has_many :projects through: :users_projects
- has_many :comments through: :users_comments
- has_many :users_projects
- has_many :users_comments

## Projectsテーブル

| Column             | Type   | Options                  |
| ------------------ | ------ | ------------------------ |
| name               | string | null: false              |

### Association
- has_many: users through: :users_projects
- has_many: tasks
- has_many: users_projects

## UsersProjectsテーブル
| Column             | Type    | Options                        |
| ------------------ | ------- | ------------------------------ |
| user_id            | integer | null: false, foreign_key: true |
| project_id         | integer | null: false, foreign_key: true |

### Association
- belongs_to: user
- belongs_to: project

## Tasksテーブル

| Column             | Type    | Options                  |
| ------------------ | ------- | ------------------------ |
| name               | string  | null: false              |
| specifics          | string  | null: false              |
| project_id         | integer | null: false              |

### Association
- belongs_to: project
- has_many: comments

## Commentsテーブル

| Column             | Type    | Options                  |
| ------------------ | ------- | ------------------------ |
| text               | string  | null: false              |
| task_id            | integer | null: false              |

### Association
- belongs_to: task
- has_many: users_comments through: :users_comments
- has_many: users_comments

## UsersCommentsテーブル
| Column             | Type    | Options                        |
| ------------------ | ------- | ------------------------------ |
| user_id            | integer | null: false, foreign_key: true |
| comment_id         | integer | null: false, foreign_key: true |

### Association
- belongs_to: user
- belongs_to: comment