FactoryBot.define do
  factory :comment do
    comment {"テスト用コメント"}
    association :task
    association :user
    img {Rack::Test::UploadedFile.new(Rails.root.join("public/images/test1.jpg"))}
  end
end
