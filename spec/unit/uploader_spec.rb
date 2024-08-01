require 'rails_helper'

RSpec.describe BookImageUploader, type: :uploader do
  let(:user) { create(:user) }
  let(:book) { create(:book, user: user) }

  before do
    BookImageUploader.enable_processing = true
    @uploader = BookImageUploader.new(book, :book_image)
    @uploader.store!(File.open(Rails.root.join('spec/images/book_image.jpg')))
  end

  after do
    BookImageUploader.enable_processing = false
    @uploader.remove!
  end

  it '正しい拡張子が許可されている' do
    expect(@uploader.extension_whitelist).to include('jpg', 'jpeg', 'png')
  end

  it '画像が正しいディレクトリに保存される' do
    expect(@uploader.store_dir).to eq("uploads/book/book_image/book_image/#{book.id}")
  end
end