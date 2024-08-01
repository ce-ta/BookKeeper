require 'rails_helper'

RSpec.describe "新規ユーザー登録機能", type: :system do
  let(:user_name) { "Test User #{SecureRandom.hex(3)}" }

  it "新規ユーザー登録" do
    visit new_user_registration_path
    fill_in 'name', with: user_name
    fill_in 'email', with: 'user@example.com'
    fill_in 'password', with: 'password'
    fill_in 'password_confirmation', with: 'password'
    attach_file 'avatar', Rails.root.join('spec/images/avatar_image.jpg')
    fill_in "bio", with: "This is test bio."
    click_button '登録'
    
    expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'

    # Simulate user clicking the confirmation link (in real test setup, fetch the token from the email)
    user = User.find_by(email: 'user@example.com')
    visit user_confirmation_path(confirmation_token: user.confirmation_token)

    visit new_user_session_path

    fill_in 'email', with: user.email
    fill_in 'password', with: 'password'
    click_button 'ログイン'
    
    expect(page).to have_current_path(books_path)
    expect(page).to have_content("ログインしました。")
  end

  it "ユーザー新規登録エラー時処理" do
    visit new_user_registration_path
    
    # Fill in invalid user information (email already taken)
    fill_in "name", with: "Test User" # This name is already taken
    fill_in "email", with: "test@example.com" # This email is already taken
    fill_in "password", with: "short"
    fill_in "password_confirmation", with: "long"
    attach_file 'avatar', Rails.root.join('spec/images/avatar_image.jpg')
    fill_in "bio", with: "This bio is way too long and should exceed the maximum allowed characters limit to trigger the error message in the form."
    click_button "登録"
    
    # Expectations for error messages
    expect(page).to have_content("メールアドレスはすでに存在します")
    expect(page).to have_content("パスワード（確認用）とパスワードの入力が一致しません")
    expect(page).to have_content("パスワードは6文字以上で入力してください")
    expect(page).to have_content("名前はすでに存在します")
    expect(page).to have_content("自己紹介文は100文字以内で入力してください")
  end
end