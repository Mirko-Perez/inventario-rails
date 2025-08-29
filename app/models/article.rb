class Article < ApplicationRecord
  belongs_to :current_person, class_name: "Person", optional: true
  has_many :transfers, dependent: :destroy

  validates :model, presence: true, length: { minimum: 2, maximum: 100 }
  validates :brand, presence: true, length: { minimum: 2, maximum: 50 }
  validates :entry_date, presence: true

  # Baja lógica
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  scope :by_brand, ->(brand) { where(brand: brand) if brand.present? }
  scope :by_model, ->(model) { where("LOWER(model) LIKE ?", "%#{model.downcase}%") if model.present? }
  scope :by_entry_date, ->(date) do
    if date.present?
      where("entry_date <= ?", Date.parse(date))
    end
  end

  def transfer_history
    transfers.includes(:from_person, :to_person).order(transfer_date: :desc)
  end

  def previous_carriers
    transfers.includes(:from_person).map(&:from_person).uniq
  end

  def display_name_with_carrier
    carrier_name = current_person&.full_name || "Unassigned"
    "#{brand} #{model} (#{carrier_name})"
  end

  def soft_delete!
    update!(deleted_at: Time.current)
  end

  def restore!
    update!(deleted_at: nil)
  end

  def deleted?
    deleted_at.present?
  end
end
