FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    image { Faker::Internet.url }
    password { '123456' }
    password_confirmation { '123456' }
    profile { %i[admin client].sample }
  end
end
