FactoryBot.define do
  factory :article do
    brand { "Dell" }
    model { "Latitude 5520" }
    entry_date { Date.current }
    association :current_person, factory: :person

    trait :hp do
      brand { "HP" }
      model { "EliteBook 840" }
    end

    trait :lenovo do
      brand { "Lenovo" }
      model { "ThinkPad X1 Carbon" }
    end

    trait :apple do
      brand { "Apple" }
      model { "MacBook Pro 14" }
    end
  end
end
