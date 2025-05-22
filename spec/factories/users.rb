FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:username) { |n| "user#{n}" }
    name { "Test User" }
    encrypted_password { 'dummy' }
    password { 'password123' }  # Deviseのバリデーション用
  end
end
