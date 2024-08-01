FactoryBot.define do
    factory :book do
      title { "Example Book" }
      author { "Example Author" }
      publisher {"publisher"}
      genre {"文学・文芸"}
      date {"20200101"}
      book_image {"spec/images/book_image.jpg"}
    end
  end