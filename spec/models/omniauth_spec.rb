require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.from_omniauth' do
    let(:auth) { mock_auth_hash }

    context '新しいユーザーの場合' do
      it 'ユーザーを作成し、認証情報を関連付ける' do
        user = User.from_omniauth(auth)
        expect(user).to be_persisted
        expect(user.name).to eq('Mock User')
        expect(user.email).to eq('mockuser@example.com')
        expect(user.authorizations.first.provider).to eq('github')
        expect(user.authorizations.first.uid).to eq('123545')
      end
    end

    context '既存のユーザーの場合' do
      let!(:existing_user) { FactoryBot.create(:user, email: 'mockuser@example.com') }

      it '既存のユーザーを返す' do
        user = User.from_omniauth(auth)
        expect(user).to eq(existing_user)
      end
    end
  end
end