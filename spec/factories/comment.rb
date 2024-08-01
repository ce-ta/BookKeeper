FactoryBot.define do
    factory :comment do
      body { "Test Comment" }
      association :post
      association :user
    end
end