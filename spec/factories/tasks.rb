FactoryBot.define do
  factory :task do
    name {"テスト用タスクネーム"}
    specifics {"テスト用タスク詳細"}
    association :project
  end
end
