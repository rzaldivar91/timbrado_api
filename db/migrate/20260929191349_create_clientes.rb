class CreateClientes < ActiveRecord::Migration[8.1]
  def change
    create_table :clientes do |t|
      t.string :nombre, null: false
      t.string :rfc, null: false

      t.timestamps
    end
  end
end
