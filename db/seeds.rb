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

# Create notifications
users = User.all
users.each do |user|
  next if user == User.first
  
  # Create follow notifications
  if Relationship.find_by(follower: user, followed: User.first)
    Notification.create!(
      user: User.first,
      notifiable: Relationship.find_by(follower: user, followed: User.first),
      action: "follow"
    )
  end
  
  # Create like notifications
  user_posts = User.first.posts
  user_posts.each do |post|
    like = Like.find_by(user: user, post: post)
    next unless like
    
    Notification.create!(
      user: User.first,
      notifiable: like,
      action: "like"
    )
  end
end

# Create search histories
users = User.all
search_terms = ["新しい", "投稿", "ユーザー", "テスト", "プロジェクト", "Rails", "Ruby"]
users.each do |user|
  search_terms.sample(3).each do |term|
    user.search_histories.create!(query: term)
  end
end

puts "Seed data created successfully!"
