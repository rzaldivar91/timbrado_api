FactoryBot.define do
  factory :factura do
    association :cliente
    folio { "A1" }
    total { 1500.50 }
    fecha_emision { Date.current }

    trait :timbrada do
      estatus { "vigente" }
      uuid_fiscal { SecureRandom.uuid }
    end

    trait :sin_timbrar do
      estatus { "pendiente" }
      uuid_fiscal { nil }
    end
  end
end
