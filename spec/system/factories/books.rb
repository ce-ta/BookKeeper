FactoryBot.define do
    factory :book do
      title { 'サンプルタイトル' }
      author { 'サンプル著者' }
      publisher { 'サンプル出版社' }
      date { '20240101' }
      genre { '文学・文芸' }
      association :user
    end
  end