require 'rails_helper'

RSpec.describe "投稿機能", type: :system do
    let(:user) { FactoryBot.create(:user) }
    let(:book) { Book.last }

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

      visit new_book_path

      fill_in "title", with: "サンプルタイトル"
      fill_in "author", with: "サンプル著者"
      fill_in "publisher", with: "サンプル出版社"
      choose 'literature' 
      fill_in "dateInput", with: "20240101"
      attach_file 'imageInput', Rails.root.join('spec/images/book_image.jpg')
      click_button "登録"
    end

    it "新規投稿機能" do
      visit "/books/#{book.id}"

      click_on "post-btn"

      fill_in 'content', with: "感想テスト"

      click_button "投稿する"

      expect(page).to have_current_path(posts_path)
      expect(page).to have_content("感想を投稿しました")
    end

    it "投稿編集機能" do
      visit "/books/#{book.id}"

      click_on "post-btn"

      fill_in 'content', with: "感想テスト"

      click_button "投稿する"

      post = Post.last

      visit "/posts/#{post.id}/edit"

      fill_in "content", with: "update 感想テスト"

      click_on "更新"
      expect(page).to have_current_path("/posts/#{post.id}")
      expect(page).to have_content("感想を編集しました")
    end

    it "投稿削除機能" do
      visit "/books/#{book.id}"
    
      click_on "post-btn"
    
      fill_in 'content', with: "感想テスト"
    
      click_button "投稿する"
    
      post = Post.last
    
      visit "/posts/#{post.id}"
    
      click_on "削除"
    
      expect(page).to have_current_path(posts_path)
      expect(page).to have_content("感想を削除しました")
    end

    it "新規投稿エラー（空白）" do
      visit "/books/#{book.id}"

      click_on "post-btn"

      fill_in 'content', with: ""

      click_button "投稿する"

      expect(page).to have_current_path("/posts")
      expect(page).to have_content("タイトルまたは感想が空白です")
    end

    it "投稿編集エラー（空白）" do
      visit "/books/#{book.id}"

      click_on "post-btn"

      fill_in 'content', with: "感想テスト"

      click_button "投稿する"

      post = Post.last

      visit "/posts/#{post.id}/edit"

      fill_in "content", with: ""

      click_on "更新"
      expect(page).to have_current_path("/posts/#{post.id}")
      expect(page).to have_content("タイトルまたは感想が空白です")
    end

    it "感想文字数制限機能（新規）" do
      visit "/books/#{book.id}"

      click_on "post-btn"

      #141文字を入力
      fill_in 'content', with: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

      click_button "投稿する"

      expect(page).to have_current_path(posts_path)
      expect(page).to have_content("感想を投稿しました")
    end
end