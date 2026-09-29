class CreateFacturas < ActiveRecord::Migration[8.1]
  def change
    create_table :facturas do |t|
      t.references :cliente, null: false, foreign_key: true
      t.string :folio, null: false
      t.decimal :total, precision: 12, scale: 2, null: false
      t.string :estatus, null: false
      t.date :fecha_emision
      t.string :uuid_fiscal

      t.timestamps
    end

    add_index :facturas, :uuid_fiscal, unique: true
    add_index :facturas, :estatus
  end
end
