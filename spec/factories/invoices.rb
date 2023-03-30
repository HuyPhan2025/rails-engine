FactoryBot.define do
  factory :invoice do
    status {"Shipped"}

    trait :package do
      status {"packaged"}
    end

    trait :package do
      status {"returned"}
    end

    factory :packaged_invoice, traits: [:packaged]
    factory :returned_invoice, traits: [:returned]
  end
end
