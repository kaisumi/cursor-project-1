# Create test users
User.create!(email: 'test@example.com', name: 'テストユーザー')
User.create!(email: 'admin@example.com', name: '管理者')

puts "Seed data created successfully!"
