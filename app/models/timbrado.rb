class Timbrado < ApplicationRecord
  belongs_to :factura

  enum :estatus, { timbrada: "timbrada", fallida: "fallida" }, validate: true

  validates :external_id, presence: true, uniqueness: true
  validates :monto, numericality: { greater_than: 0 }
  validates :error, presence: true, if: :fallida?
end
