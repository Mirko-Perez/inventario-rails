class Article < ApplicationRecord
  belongs_to :current_person, class_name: 'Person'
  has_many :transfers, dependent: :destroy

  validates :model, presence: true, length: { minimum: 2, maximum: 100 }
  validates :brand, presence: true, length: { minimum: 2, maximum: 50 }
  validates :entry_date, presence: true
  validates :current_person_id, presence: true

  scope :by_brand, ->(brand) { where(brand: brand) if brand.present? }
  scope :by_model, ->(model) { where('model LIKE ?', "%#{model}%") if model.present? }
  scope :by_entry_date, ->(date) { where(entry_date: date) if date.present? }

  def transfer_history
    transfers.includes(:from_person, :to_person).order(transfer_date: :desc)
  end

  def previous_carriers
    transfers.includes(:from_person).map(&:from_person).uniq
  end
end
