require 'rails_helper'

RSpec.describe 'GitHub OAuth Login', type: :system do
  before do
    mock_auth_hash
  end

  it 'GitHubでログインする' do
    visit new_user_session_path
    find('#github_signin_button').click # IDを使ってボタンをクリック

    # Simulate user clicking the confirmation link (in real test setup, fetch the token from the email)
    user = User.find_by(email: 'mockuser@example.com')
    visit user_confirmation_path(confirmation_token: user.confirmation_token)

    visit new_user_session_path

    find('#github_signin_button').click

    expect(page).to have_content('Github アカウントによる認証に成功しました。') # ログイン成功後のメッセージを検証
    expect(User.last.email).to eq('mockuser@example.com') # ユーザーのメールアドレスを検証
  end
end