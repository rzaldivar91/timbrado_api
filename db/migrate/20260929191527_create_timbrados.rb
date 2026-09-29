class CreateTimbrados < ActiveRecord::Migration[8.1]
  def change
    create_table :timbrados do |t|
      t.references :factura, null: false, foreign_key: true
      t.string :external_id, null: false
      t.decimal :monto, precision: 12, scale: 2, null: false
      t.string :estatus, null: false
      t.string :error

      t.timestamps
    end
  end
end
