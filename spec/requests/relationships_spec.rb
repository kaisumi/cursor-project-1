require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    login_as(user, scope: :user)
  end

  describe "POST /relationships" do
    context "with valid params" do
      it "creates a new relationship" do
        expect {
          post relationships_path(format: :turbo_stream), params: { followed_id: other_user.id }
        }.to change(Relationship, :count).by(1)
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq Mime[:turbo_stream]
      end
    end

    context "when following self" do
      it "does not create a relationship" do
        expect {
          post relationships_path(format: :turbo_stream), params: { followed_id: user.id }
        }.not_to change(Relationship, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.media_type).to eq Mime[:turbo_stream]
      end
    end
  end

  describe "DELETE /relationships" do
    before do
      user.follow(other_user)
    end

    it "destroys the relationship" do
      expect(Relationship.count).to eq(1)
      relationship = Relationship.last
      
      expect {
        delete relationship_path(relationship, format: :turbo_stream, followed_id: other_user.id)
      }.to change(Relationship, :count).by(-1)
      
      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq Mime[:turbo_stream]
    end
  end

  context "when not signed in" do
    before do
      logout(:user)
    end

    it "redirects to sign in page when trying to follow" do
      post relationships_path, params: { followed_id: other_user.id }
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects to sign in page when trying to unfollow" do
      relationship = create(:relationship, follower: user, followed: other_user)
      delete relationship_path(relationship)
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
