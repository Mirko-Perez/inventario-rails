class Article < ApplicationRecord
  include SoftDeletable
  belongs_to :current_person, class_name: "Person", optional: false
  has_many :transfers, dependent: :destroy

  validates :model, presence: true, length: { minimum: 2, maximum: 100 }
  validates :brand, presence: true, length: { minimum: 2, maximum: 50 }
  validates :entry_date, presence: true

  scope :by_brand, ->(brand) { where(brand: brand) if brand.present? }
  scope :by_model, ->(model) { where("LOWER(model) LIKE ?", "%#{model.downcase}%") if model.present? }
  scope :by_entry_date, ->(date) do
    if date.present?
      parsed = date.is_a?(Date) ? date : Date.parse(date.to_s)
      where("entry_date <= ?", parsed)
    end
  end

  def transfer_history
    transfers.includes(:from_person, :to_person).order(transfer_date: :desc, created_at: :desc)
  end

  def previous_carriers
    transfers.includes(:from_person).map(&:from_person).uniq
  end

  def display_name_with_carrier
    carrier_name = current_person&.full_name || "Unassigned"
    "#{brand} #{model} (#{carrier_name})"
  end
end
