FactoryBot.define do
  factory :comment do
    content { "Comment content for testing" }
    association :user, factory: :user
    association :post, factory: :post
  end
end
