class Transfer < ApplicationRecord
  belongs_to :article
  belongs_to :from_person
  belongs_to :to_person
end
