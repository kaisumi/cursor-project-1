# Create test users
User.create!(email: 'test@example.com', name: 'テストユーザー')
User.create!(email: 'admin@example.com', name: '管理者')

# Create additional users
8.times do |n|
  User.create!(
    email: "user#{n+1}@example.com",
    name: "ユーザー#{n+1}"
  )
end

# Create posts
users = User.all
users.each do |user|
  5.times do |n|
    user.posts.create!(
      content: "これはユーザー#{user.id}の#{n+1}番目の投稿です。"
    )
  end
end

# Create relationships
users = User.all
user = users.first
following = users[2..8]
followers = users[3..9]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# Create likes
users = User.all
posts = Post.all
users.each do |user|
  posts.sample(10).each do |post|
    user.like(post) unless user.likes?(post)
  end
end

puts "Seed data created successfully!"
