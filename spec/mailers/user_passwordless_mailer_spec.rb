require 'rails_helper'

RSpec.describe UserPasswordlessMailer, type: :mailer do
  let(:user) { create(:user, email: 'test@example.com') }
  let(:token) { 'valid_token' }
  let(:mail) { described_class.magic_link(user, token) }

  describe '#magic_link' do
    it 'renders the headers' do
      expect(mail.subject).to eq('ログインリンク')
      expect(mail.to).to eq([ user.email ])
      expect(mail.from).to eq([ 'from@example.com' ])
    end

    it 'renders the body' do
      text_part = mail.text_part ? mail.text_part.body.decoded : mail.body.decoded
      expect(text_part).to include('ログインするには以下のリンクをクリックしてください')
      expect(text_part).to include(token)
    end
  end
end
