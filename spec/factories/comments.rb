FactoryBot.define do
  factory :comment do
    comment {"テスト用コメント"}
    association :task
    association :user
    img {Rack::Test::UploadedFile.new(Rails.root.join("public/images/3594440_s.jpg"))}
  end
end
