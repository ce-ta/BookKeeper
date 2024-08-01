require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }

  describe 'バリデーション' do
    it 'タイトルが存在すること' do
      post.title = ''
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include("を入力してください")
    end

    it 'ジャンルが存在すること' do
      post.genre = ''
      expect(post).not_to be_valid
      expect(post.errors[:genre]).to include("を入力してください")
    end

    it '内容が存在すること' do
      post.content = ''
      expect(post).not_to be_valid
      expect(post.errors[:content]).to include("を入力してください")
    end

    it '内容の長さが140文字以内であること' do
      post.content = 'a' * 141
      expect(post).not_to be_valid
      expect(post.errors[:content]).to include("は140文字以内で入力してください")
    end

    it 'ユーザーIDが存在すること' do
      post.user_id = nil
      expect(post).not_to be_valid
      expect(post.errors[:user_id]).to include("を入力してください")
    end
  end

  describe 'アソシエーション' do
    it 'ユーザーに属していること' do
      expect(post.user).to eq(user)
    end

    it 'アソシエーション コメントを持っていること' do
        user = create(:user)
        post = create(:post, user: user)
        comment = create(:comment, post: post, user: user)
        expect(post.comments).to include(comment)
    end

    it 'お気に入りを持っていること' do
        user = create(:user)
        post = create(:post, user: user)
        favorite = create(:favorite, user: user, post: post)
        expect(post.favorites).to include(favorite)
    end

    it 'お気に入りユーザーを持っていること' do
        user = create(:user)
        post = create(:post, user: user)
        favorite = create(:favorite, user: user, post: post)
        expect(post.favorited_by_users).to include(user)
    end
  end

  describe 'インスタンスメソッド' do
    describe '#favorited_by?' do
      it 'ユーザーがお気に入りしている場合、trueを返すこと' do
        create(:favorite, post: post, user: user)
        expect(post.favorited_by?(user)).to be true
      end

      it 'ユーザーがお気に入りしていない場合、falseを返すこと' do
        expect(post.favorited_by?(user)).to be false
      end
    end
  end
end