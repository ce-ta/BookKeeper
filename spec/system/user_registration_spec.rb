require 'rails_helper'

# spec/system/user_registration_spec.rb

RSpec.describe "新規ユーザー登録機能", type: :system do
    before(:all) do
      # 共通のユーザーを作成
      @existing_user = User.create!(name: "Test User", email: "test@example.com", password: "password123", password_confirmation: "password123", bio: "This is a test bio.")
    end
  
    after(:all) do
      # テストデータをクリア
      @existing_user.destroy
    end
  
    it "新規ユーザー登録" do
      visit "/signup"
      
      # Fill in valid user information
      fill_in "name", with: "Test User 2"
      fill_in "email", with: "test2@example.com"
      fill_in "password", with: "password123"
      fill_in "password_confirmation", with: "password123"
      fill_in "bio", with: "This is a test bio."
      click_button "登録"
      
      # Expectations after successful registration
      expect(page).to have_current_path(books_path)
      expect(page).to have_content("ユーザー登録が完了しました")
    end
  
    it "ユーザー新規登録エラー時処理" do
      visit "/signup"
      
      # Fill in invalid user information (email already taken)
      fill_in "name", with: "Test User" # This name is already taken
      fill_in "email", with: "test@example.com" # This email is already taken
      fill_in "password", with: "short"
      fill_in "password_confirmation", with: "long"
      fill_in "bio", with: "This bio is way too long and should exceed the maximum allowed characters limit to trigger the error message in the form."
      click_button "登録"
      
      # Expectations for error messages
      expect(page).to have_content("すでに同じ名前のユーザーがいます")
      expect(page).to have_content("このメールアドレスは既に使用されています")
      expect(page).to have_content("パスワードと確認用パスワードが一致しません")
      expect(page).to have_content("パスワードは8文字以上で入力してください")
      expect(page).to have_content("自己紹介は100文字以内で入力してください")
    end
  end