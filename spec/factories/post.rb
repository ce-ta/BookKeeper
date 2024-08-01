FactoryBot.define do
    factory :post do
        title { "Test Title" }
        genre { "文学・文芸" }
        content { "Test Content" }
        association :user
    end
end