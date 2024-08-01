require 'rails_helper'

RSpec.describe "ログイン・ログアウト機能", type: :system do
  before do
    visit new_user_registration_path

    fill_in 'name', with: 'Test User1'
    fill_in 'email', with: 'test@email.com'
    fill_in 'password', with: 'password'
    fill_in 'password_confirmation', with: 'password'
    click_button '登録'
    
    expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'

    # Simulate user clicking the confirmation link (in real test setup, fetch the token from the email)
    user = User.find_by(email: 'test@email.com')
    visit user_confirmation_path(confirmation_token: user.confirmation_token)
  end

  it "ログイン機能" do
    visit new_user_session_path

    fill_in 'email', with: 'test@email.com'
    fill_in 'password', with: 'password'
    click_button 'ログイン'

    expect(current_path).to eq(books_path)
    expect(page).to have_content('ログインしました')
  end

  it "ログイン時エラーメッセージ機能" do
    visit new_user_session_path

    fill_in 'email', with: 'test@email.com'
    fill_in 'password', with: 'wrong_password'
    click_button 'ログイン'

    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content('メールアドレスまたはパスワードが違います。')
  end

  it "ログアウト機能" do
    visit new_user_session_path

    fill_in 'email', with: 'test@email.com'
    fill_in 'password', with: 'password'
    click_button 'ログイン'

    click_button 'ログアウト'

    expect(page).to have_current_path('/')
    expect(page).to have_content('ログアウトしました')
  end
end