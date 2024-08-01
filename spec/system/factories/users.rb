FactoryBot.define do
    factory :user do
      name { 'サンプルユーザー' }
      email { 'sample@example.com' }
      password { 'password' }
      password_confirmation { 'password' }
    end
  end