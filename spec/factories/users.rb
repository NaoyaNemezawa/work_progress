FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    password {Faker::Internet.password(min_length: 6)}
    password_confirmation {password}

    after(:create) do |user|
      create(:user_project, user: user, project: create(:project))
    end
  end
end
