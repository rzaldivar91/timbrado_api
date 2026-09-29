class TimbradosController < ApplicationController
  before_action :busca_factura

  def create
    return error_response if payload_errores.any?
    @factura.with_lock do
      return success_response if timbrado_previamente

      resultado = Facturas::Timbrador.new(@factura, params).ejecuta
      render json: resultado[:respuesta_pac], status: resultado[:status]
    end
  rescue ActiveRecord::RecordNotFound
    render json: {
      error: "Factura no encontrada"
    }, status: :not_found
  end

  private

  def payload_errores
    errors = []

    errors << "external_id es requerido" if params[:external_id].blank?
    errors << "invoice_id es requerido" if params[:invoice_id].blank?
    errors << "amount es requerido" if params[:amount].blank?

    errors
  end

  def error_response
    render json: {
      error: "Payload inválido",
      details: payload_errores
    }, status: :bad_request
  end

  def success_response
    if @timbrado.estatus == "timbrada"
      respuesta = {
        status: @timbrado.estatus,
        external_id: @timbrado.external_id,
        uuid_fiscal: @factura.uuid_fiscal
      }
    else
      respuesta = {
        status: @timbrado.estatus,
        external_id: @timbrado.external_id,
        error: @timbrado.error
      }
    end

    render json: respuesta, status: :ok
  end

  def timbrado_previamente
    @timbrado = Timbrado.where(external_id: params[:external_id]).first
    @timbrado.present?
  end

  def busca_factura
    @factura = Factura.find(params[:invoice_id])
  end
end
