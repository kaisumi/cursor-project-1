FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "テスト投稿#{n}" }
    sequence(:content) { |n| "これはテスト投稿#{n}の内容です。" }
    association :user

    trait :with_comments do
      after(:create) do |post|
        create_list(:comment, 3, post: post)
      end
    end

    trait :with_likes do
      after(:create) do |post|
        create_list(:like, 3, post: post)
      end
    end
  end
end
