require 'rails_helper'

RSpec.describe "ユーザー編集機能", type: :system do
  let(:user) { FactoryBot.create(:user) }
  before do
    visit new_user_registration_path

    fill_in 'name', with: 'Test User1'
    fill_in 'email', with: 'test@email.com'
    fill_in 'password', with: 'password'
    fill_in 'password_confirmation', with: 'password'
    click_button '登録'
    
    expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'

    registered_user = User.find_by(email: 'test@email.com')
    visit user_confirmation_path(confirmation_token: registered_user.confirmation_token)

    visit new_user_session_path

    fill_in 'email', with: 'test@email.com'
    fill_in 'password', with: 'password'
    click_button 'ログイン'
  end

  it "ユーザー情報の更新" do
    visit edit_user_registration_path
    
    # Fill in valid user information
    fill_in "name", with: "Updated Test User"
    fill_in "email", with: "updated_test@example.com"
    fill_in "bio", with: "Updated bio."
    click_button "保存"
    
    # Expectations after successful update
    expect(page).to have_content 'アカウント情報を変更しました。変更されたメールアドレスの本人確認のため、本人確認用メールより確認処理をおこなってください。'

    updated_user = User.find_by(name: 'Updated Test User')
    visit user_confirmation_path(confirmation_token: updated_user.confirmation_token)

    expect(page).to have_current_path("/")
    expect(page).to have_content("メールアドレスが確認できました。")
  end

  it "ユーザー編集エラー時処理" do
    visit edit_user_registration_path

    fill_in "name", with: user.name
    fill_in "email", with: user.email

    # bioはjavascriptで100文字以降は入力制限がかかり削除される
    fill_in "bio", with: "This bio is way too long and should exceed the maximum allowed characters limit to trigger the error message in the form."
    click_button "保存"
    
    # Expectations for error messages
    expect(page).to have_content("名前はすでに存在します")
    expect(page).to have_content("メールアドレスはすでに存在します")
  end

  it "ユーザーの削除" do
    visit "users/2"

    click_button "削除"

    page.driver.browser.switch_to.alert.accept

    expect(page).to have_current_path("/")
    expect(page).to have_content("ユーザーを削除しました。")
  end
end