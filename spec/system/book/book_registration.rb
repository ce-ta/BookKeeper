require 'rails_helper'

RSpec.describe "書籍管理機能", type: :system do
  let(:user) { FactoryBot.create(:user) }
  before do
    visit new_user_registration_path

    fill_in 'name', with: 'Test User1'
    fill_in 'email', with: 'test@email.com'
    fill_in 'password', with: 'password'
    fill_in 'password_confirmation', with: 'password'
    click_button '登録'

    registered_user = User.find_by(email: 'test@email.com')
    visit user_confirmation_path(confirmation_token: registered_user.confirmation_token)

    visit new_user_session_path

    fill_in 'email', with: 'test@email.com'
    fill_in 'password', with: 'password'
    click_button 'ログイン'

    visit new_book_path
  end

  it "書籍登録" do
    fill_in "title", with: "サンプルタイトル"
    fill_in "author", with: "サンプル著者"
    fill_in "publisher", with: "サンプル出版社"
    choose 'literature' 
    fill_in "dateInput", with: "20240101"
    attach_file 'imageInput', Rails.root.join('spec/images/book_image.jpg')

    click_button "登録"
    
    expect(page).to have_current_path(books_path)
    expect(page).to have_content('書籍が正常に登録されました')
  end

  it "書籍登録時エラー(空白)" do
    fill_in "title", with: ""
    fill_in "author", with: ""
    fill_in "publisher", with: ""
    choose '' 
    fill_in "dateInput", with: ""
    attach_file 'imageInput', Rails.root.join('spec/images/book_image.jpg')

    click_button "登録"
    
    expect(page).to have_content('')
  end
end