require 'rails_helper'

RSpec.describe "Timbrados", type: :request do
  describe "POST /create" do
    context 'Cuando la información es válida' do
      let(:factura) { FactoryBot.create(:factura, :sin_timbrar) }
      let(:params) do
        {
          external_id: "ext-id-1",
          invoice_id: factura.id,
          amount: factura.total
        }
      end

      it 'El PAC timbra exitosamente' do
        post "/timbrados", params: params

        body = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(body["external_id"]).to eq("ext-id-1")
        expect(body["status"]).to eq(factura.reload.estatus)
      end
    end

    context 'Cuando existe un timbre previo' do
      let(:factura2) { FactoryBot.create(:factura, :timbrada) }
      let(:timbrado) { FactoryBot.create(:timbrado, :timbrada, factura: factura2, monto: factura2.total) }
      let(:params) do
        {
          external_id: timbrado.external_id,
          invoice_id: factura2.id,
          amount: factura2.total
        }
      end

      it 'Devuelve la respuesta success del primer timbrado' do
        post "/timbrados", params: params

        body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(body["external_id"]).to eq(timbrado.external_id)
        expect(body["status"]).to eq(timbrado.estatus)
        expect(body["uuid_fiscal"]).to eq(factura2.uuid_fiscal)
      end
    end

    context 'Cuando existe un intento de timbrado fallido previo' do
      let(:factura3) { FactoryBot.create(:factura, :sin_timbrar) }
      let(:timbrado2) { FactoryBot.create(:timbrado, :fallida, factura: factura3, monto: factura3.total) }
      let(:params) do
        {
          external_id: timbrado2.external_id,
          invoice_id: factura3.id,
          amount: factura3.total
        }
      end

      it 'Devuelve la respuesta fallida del primer intento de timbrado' do
        post "/timbrados", params: params

        body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(body["external_id"]).to eq(timbrado2.external_id)
        expect(body["status"]).to eq(timbrado2.estatus)
        expect(body["error"]).to eq(timbrado2.error)
      end
    end

    context "Cuando el PAC falla" do
      let(:factura4) { FactoryBot.create(:factura, :sin_timbrar) }
      let(:params) do
        {
          external_id: "ext-id-fallido",
          invoice_id: factura4.id,
          amount: factura4.total
        }
      end

      before do
        allow(Pac::FakePac).to receive(:new)
          .and_return(Pac::FakePac.new(params, true))
      end

      it "Crea un timbrado fallido y devuelve 422" do
        post "/timbrados", params: params

        body = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_content)
        expect(body["status"]).to eq("fallida")
        expect(body["external_id"]).to eq("ext-id-fallido")
        expect(body["error"]).to eq("timeout")
      end
    end
  end
end
