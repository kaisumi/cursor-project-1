require 'rails_helper'

RSpec.describe SearchHistory, type: :model do
  let(:user) { create(:user) }
  
  it "is valid with valid attributes" do
    search_history = SearchHistory.new(
      user: user,
      query: "test query"
    )
    expect(search_history).to be_valid
  end
  
  it "is not valid without a query" do
    search_history = SearchHistory.new(
      user: user,
      query: nil
    )
    expect(search_history).not_to be_valid
  end
  
  it "is not valid without a user" do
    search_history = SearchHistory.new(
      user: nil,
      query: "test query"
    )
    expect(search_history).not_to be_valid
  end
  
  describe "scopes" do
    before do
      @user = create(:user)
      
      # Create 15 search histories with different timestamps
      15.times do |i|
        SearchHistory.create!(
          user: @user,
          query: "query #{i}",
          created_at: Time.now - i.hours
        )
      end
    end
    
    it "returns only 10 recent search histories with recent scope" do
      expect(SearchHistory.recent.count).to eq(10)
      expect(SearchHistory.recent.first.query).to eq("query 0")
      expect(SearchHistory.recent.last.query).to eq("query 9")
    end
  end
  
  describe ".popular" do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)
      
      # Create search histories with different frequencies
      3.times { SearchHistory.create!(user: @user1, query: "ruby") }
      2.times { SearchHistory.create!(user: @user2, query: "ruby") }
      2.times { SearchHistory.create!(user: @user1, query: "rails") }
      1.times { SearchHistory.create!(user: @user3, query: "rails") }
      1.times { SearchHistory.create!(user: @user2, query: "javascript") }
    end
    
    it "returns search queries ordered by popularity" do
      popular = SearchHistory.popular
      expect(popular.keys.first).to eq("ruby")
      expect(popular.keys.second).to eq("rails")
      expect(popular.keys.third).to eq("javascript")
      
      expect(popular["ruby"]).to eq(5)
      expect(popular["rails"]).to eq(3)
      expect(popular["javascript"]).to eq(1)
    end
  end
end
