class Cliente < ApplicationRecord
  has_many :facturas, dependent: :restrict_with_error

  validates :nombre, :rfc, presence: true

  def self.saldos_facturacion
    joins("LEFT JOIN facturas ON facturas.cliente_id = clientes.id")
    .joins(<<~SQL.squish)
      LEFT JOIN (
        SELECT factura_id, SUM(monto) AS pagado FROM pagos GROUP BY factura_id
      ) pf ON pf.factura_id = facturas.id
    SQL
    .group("clientes.id")
    .select(<<~SQL.squish)
      clientes.id, clientes.nombre, clientes.rfc,
      COALESCE(SUM(facturas.total), 0) AS total_facturado,
      COALESCE(SUM(pf.pagado), 0) AS total_pagado
    SQL
  end
end
