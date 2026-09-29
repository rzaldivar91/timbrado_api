class CreatePagos < ActiveRecord::Migration[8.1]
  def change
    create_table :pagos do |t|
      t.references :factura, null: false, foreign_key: true
      t.decimal :monto, precision: 12, scale: 2, null: false
      t.date :fecha_pago, null: false

      t.timestamps
    end
  end
end
