FactoryBot.define do
  factory :invoice do
    status {"Shipped"}

    trait :package do
      status {"packaged"}
    end

    trait :package do
      status {"returned"}
    end

    factory :packaged_invoice, trait: [:packaged]
    factory :returned_invoice, trait: [:returned]
  end
end
