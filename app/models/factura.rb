class Factura < ApplicationRecord
  belongs_to :cliente

  has_many :pagos, dependent: :restrict_with_error
  has_many :timbrados, dependent: :restrict_with_error

  validates :folio, :total, :estatus, presence: true

  def self.vencidas_con_saldo_pendiente
    where(estatus: "vencida")
      .left_joins(:pagos)
      .group("facturas.id")
      .having("facturas.total - COALESCE(SUM(pagos.monto), 0) > 0")
      .select("facturas.*, facturas.total - COALESCE(SUM(pagos.monto), 0) AS saldo_pendiente")
  end
end
