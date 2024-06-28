require 'rails_helper'

RSpec.describe "ユーザー編集機能", type: :system do
    let!(:user) do
        User.create!(
          name: "Test User",
          email: "test@example.com",
          password: "password123",
          password_confirmation: "password123",
          bio: "This is a test bio."
        )
    end
      
    let!(:another_user) do
        User.create!(
          name: "another User",
          email: "another@example.com",
          password: "password456",
          password_confirmation: "password456",
          bio: "This is another test bio."
        )
    end
      
    after(:each) do
        user.update(name: "Test User", email: "test@example.com", bio: "This is a test bio.")
        another_user.destroy
    end

  it "ユーザー情報の更新" do
    visit "/login"
    
    fill_in "email", with: "test@example.com"
    fill_in "password", with: "password123"
    click_button "ログイン"

    visit "/users/#{user.id}/edit"
    
    # Fill in valid user information
    fill_in "name", with: "Updated Test User"
    fill_in "email", with: "updated_test@example.com"
    fill_in "bio", with: "Updated bio."
    click_button "保存"
    
    # Expectations after successful update
    expect(page).to have_current_path(user_path(user))
    expect(page).to have_content("ユーザー情報を更新しました")
  end

  it "ユーザー編集エラー時処理" do
    visit "/login"

    fill_in "email", with: "test@example.com"
    fill_in "password", with: "password123"
    click_button "ログイン"

    visit "/users/#{user.id}/edit"

    fill_in "name", with: "another User"
    fill_in "email", with: "another@example.com"
    fill_in "bio", with: "This bio is way too long and should exceed the maximum allowed characters limit to trigger the error message in the form."
    click_button "保存"
    
    # Expectations for error messages
    expect(page).to have_content("すでに同じ名前のユーザーがいます")
    expect(page).to have_content("このメールアドレスは既に使用されています")
    expect(page).to have_content("自己紹介は100文字以内で入力してください")
  end
end