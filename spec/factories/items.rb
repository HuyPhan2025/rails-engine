FactoryBot.define do
  factory :item do
    name { Faker::Name.name }
    description { Faker::Hipster.sentence }
    unit_price {Faker::Number.decimal(l_digits: 2)}
    association :merchant
  end
end
