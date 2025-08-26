FactoryBot.define do
  factory :transfer do
    association :article
    association :from_person, factory: :person
    association :to_person, factory: [ :person, :maria ]
    transfer_date { Date.current }
    notes { "Test transfer" }

    # Ensure the from_person is the current carrier of the article
    after(:build) do |transfer|
      transfer.article.current_person = transfer.from_person if transfer.article
    end
  end
end
