class ReportesController < ApplicationController
  def clientes_resumen
    render json: Cliente.saldos_facturacion
  end

  def facturas_vencidas
    render json: Factura.vencidas_con_saldo_pendiente
  end
end
