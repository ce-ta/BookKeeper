FactoryBot.define do
    factory :user do
        sequence(:name) { |n| "Test User #{n}" }
        email { "user@example.com" }
        password { "password" }
        password_confirmation { "password" }
        bio { "TestMessage" }
    end
end