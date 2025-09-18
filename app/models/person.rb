class Person < ApplicationRecord
  include SoftDeletable
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
           .order(transfer_date: :desc, created_at: :desc)
  end

  # Al eliminar (soft) una persona, reasignar los artículos que porta actualmente
  # para que no quede una persona eliminada como current carrier.
  def soft_delete!
    ActiveRecord::Base.transaction do
      super
      reassign_current_articles_after_deletion
    end
  end

  def restore!
    update!(deleted_at: nil)
  end

  def deleted?
    deleted_at.present?
  end

  private

  def reassign_current_articles_after_deletion
    current_articles.find_each do |article|
      # Buscar la última transferencia ACTIVA cuyo destinatario (to_person) esté ACTIVO
      last_valid_transfer = article.transfers.active
                                   .joins(:to_person)
                                   .where(people: { deleted_at: nil })
                                   .order(transfer_date: :desc, created_at: :desc)
                                   .first

      if last_valid_transfer
        article.update!(current_person_id: last_valid_transfer.to_person_id)
      else
        # Si no hay transferencias válidas, intentar volver al portador original si sigue activo
        original_transfer = article.transfers.with_deleted.order(created_at: :asc).first
        if original_transfer && original_transfer.from_person&.deleted_at.nil?
          article.update!(current_person_id: original_transfer.from_person_id)
        else
          # Como último recurso, dejar sin asignar
          article.update!(current_person_id: nil)
        end
      end
    end
  end
end
