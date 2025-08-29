class Transfer < ApplicationRecord
  belongs_to :article
  belongs_to :from_person, class_name: "Person"
  belongs_to :to_person, class_name: "Person"

  validates :transfer_date, presence: true
  validates :from_person_id, presence: true
  validates :to_person_id, presence: true
  validates :article_id, presence: true
  validate :different_persons
  validate :from_person_must_be_current_carrier

  after_create :update_article_current_person

  scope :recent, -> { order(transfer_date: :desc, created_at: :desc) }

  private

  def different_persons
    if from_person_id == to_person_id
      errors.add(:to_person_id, "cannot be the same as from person")
    end
  end

  def from_person_must_be_current_carrier
    if article && from_person_id != article.current_person_id
      errors.add(:from_person_id, "must be the current carrier of the article")
    end
  end

  def update_article_current_person
    article.update!(current_person_id: to_person_id)
  end
end
