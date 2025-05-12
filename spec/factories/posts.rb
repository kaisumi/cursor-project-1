FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Post Title #{n}" }
    content { "Post content for testing" }
    association :user, factory: :user
  end
end
