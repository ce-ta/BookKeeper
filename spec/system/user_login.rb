# spec/system/user_login_spec.rb
require 'rails_helper'

RSpec.describe "ログイン・ログアウト機能", type: :system do
    let(:user) { User.create(name: "test-user", email: "user@example.com", password: "password", password_confirmation: "password",  bio: "This is a test bio.") }

  it "ログイン機能" do
    visit '/login'
    fill_in 'email', with: user.email
    fill_in 'password', with: 'password'
    click_button 'ログイン'

    expect(current_path).to eq(books_path)
    expect(page).to have_content('ログインしました')
  end

  it "ログイン時エラーメッセージ機能" do
    visit '/login'
    fill_in 'email', with: user.email
    fill_in 'password', with: 'wrong_password'
    click_button 'ログイン'

    expect(page).to have_content('メールアドレスまたはパスワードが間違っています')
    expect(page).to have_selector('form[action="/login"]')
  end

  it "ログアウト機能" do
    visit '/login'
    fill_in 'email', with: user.email
    fill_in 'password', with: 'password'
    click_button 'ログイン'

    click_link 'ログアウト'

    expect(current_path).to eq(login_path)
    expect(page).to have_content('ログアウトしました')
  end
end