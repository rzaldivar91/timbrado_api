FactoryBot.define do
  factory :pago do
    association :factura
    monto { 500.00 }
    fecha_pago { Date.current }
  end
end
