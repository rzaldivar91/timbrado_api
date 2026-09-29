FactoryBot.define do
  factory :timbrado do
    association :factura
    external_id { SecureRandom.uuid }
    monto { 1500.50 }

    trait :timbrada do
      estatus { "timbrada" }
      error { nil }
    end

    trait :fallida do
      estatus { "fallida" }
      error { "timeout" }
    end
  end
end
