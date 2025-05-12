FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    encrypted_password { 'dummy' }
    password { 'password123' }  # Deviseのバリデーション用
  end
end
