# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_29_191527) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "clientes", force: :cascade do |t|
    t.string "nombre", null: false
    t.string "rfc", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "facturas", force: :cascade do |t|
    t.bigint "cliente_id", null: false
    t.string "folio", null: false
    t.decimal "total", precision: 12, scale: 2, null: false
    t.string "estatus", null: false
    t.date "fecha_emision"
    t.string "uuid_fiscal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_facturas_on_cliente_id"
    t.index ["estatus"], name: "index_facturas_on_estatus"
    t.index ["uuid_fiscal"], name: "index_facturas_on_uuid_fiscal", unique: true
  end

  create_table "pagos", force: :cascade do |t|
    t.bigint "factura_id", null: false
    t.decimal "monto", precision: 12, scale: 2, null: false
    t.date "fecha_pago", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["factura_id"], name: "index_pagos_on_factura_id"
  end

  create_table "timbrados", force: :cascade do |t|
    t.bigint "factura_id", null: false
    t.string "external_id", null: false
    t.decimal "monto", precision: 12, scale: 2, null: false
    t.string "estatus", null: false
    t.string "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["factura_id"], name: "index_timbrados_on_factura_id"
  end

  add_foreign_key "facturas", "clientes"
  add_foreign_key "pagos", "facturas"
  add_foreign_key "timbrados", "facturas"
end
