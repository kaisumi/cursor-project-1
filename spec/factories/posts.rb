FactoryBot.define do
  factory :post do
    content { "This is a test post" }
    user
  end
end
