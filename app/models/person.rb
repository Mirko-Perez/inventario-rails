class Person < ApplicationRecord
  has_many :current_articles, class_name: "Article", foreign_key: "current_person_id", dependent: :restrict_with_error
  has_many :transfers_from, class_name: "Transfer", foreign_key: "from_person_id", dependent: :restrict_with_error
  has_many :transfers_to, class_name: "Transfer", foreign_key: "to_person_id", dependent: :restrict_with_error

  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }

  # Baja lógica
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def transfer_history
    Transfer.where("from_person_id = ? OR to_person_id = ?", id, id)
           .includes(:article, :from_person, :to_person)
           .order(transfer_date: :desc)
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
