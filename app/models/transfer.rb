class Transfer < ApplicationRecord
  include SoftDeletable
  belongs_to :article
  belongs_to :from_person, class_name: "Person"
  belongs_to :to_person, class_name: "Person"

  validates :transfer_date, presence: true
  validates :from_person_id, presence: true
  validates :to_person_id, presence: true
  validates :article_id, presence: true
  validate :different_persons, on: :create
  validate :from_person_must_be_current_carrier, on: :create

  after_create :update_article_current_person
  after_update :recalculate_current_person_if_deleted, if: :saved_change_to_deleted_at?

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

  # Ejecuta el recálculo cuando la transferencia pasa a borrada lógicamente
  def recalculate_current_person_if_deleted
    return unless deleted_at.present?
    recalculate_current_person_for_article
  end

  # Recalcula el current_person_id del artículo basado en el último estado activo
  def recalculate_current_person_for_article
    # Busca la última transferencia activa (no borrada) distinta de esta
    last_active_transfer = article.transfers.active
                                 .where.not(id: id)
                                 .order(transfer_date: :desc, created_at: :desc)
                                 .first

    if last_active_transfer
      # Si existe, el portador actual es el to_person de esa transferencia
      article.update!(current_person_id: last_active_transfer.to_person_id)
    else
      # Si no hay transferencias activas, volvemos al portador original
      original_transfer = article.transfers.with_deleted.order(created_at: :asc).first
      if original_transfer
        article.update!(current_person_id: original_transfer.from_person_id)
      end
    end
  end
end
