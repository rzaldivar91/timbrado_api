module Facturas
  class Timbrador
    def initialize(factura, params)
      @factura = factura
      @params = params
    end

    def ejecuta
      resultado = pac.timbrar
      if resultado[:status] == "timbrada"
        Timbrado.create!(
          factura: @factura,
          external_id: @params[:external_id],
          monto: @params[:amount],
          estatus: resultado[:status]
        )
        @factura.update(estatus: resultado[:status], uuid_fiscal: resultado[:uuid_fiscal])
      else
        Timbrado.create!(
          factura: @factura,
          external_id: @params[:external_id],
          monto: @params[:amount],
          estatus: resultado[:status],
          error: resultado[:error]
        )
      end

      {
        respuesta_pac: resultado,
        status: resultado[:status] == "timbrada" ? :created : :unprocessable_content
      }
    end

    private

    def pac
      @pac ||= Pac::FakePac.new(@params)
    end
  end
end
