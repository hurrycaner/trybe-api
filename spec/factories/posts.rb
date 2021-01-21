FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Title #{n}" }
    content { Faker::Lorem.paragraph }
    user
  end
end
