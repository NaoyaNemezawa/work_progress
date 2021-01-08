FactoryBot.define do
  factory :comment do
    comment {"テスト用コメント"}
    association :task
    association :user
  end
end
