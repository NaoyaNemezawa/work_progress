FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    password {Faker::Internet.password(min_length: 6)}
    password_confirmation {password}

    trait :user_with_projects do
      after(:build) do |user|
        user.projects << build(:project)
      end
    end
  end
end
