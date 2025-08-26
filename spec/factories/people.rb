FactoryBot.define do
  factory :person do
    first_name { "Juan" }
    last_name { "Pérez" }
    
    trait :maria do
      first_name { "María" }
      last_name { "González" }
    end
    
    trait :carlos do
      first_name { "Carlos" }
      last_name { "Rodríguez" }
    end
  end
end
