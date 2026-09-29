class Pago < ApplicationRecord
  belongs_to :factura

  validates :monto, numericality: { greater_than: 0 }
  validates :fecha_pago, presence: true
end
