# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20191003001823) do

  create_table "localidadts", force: :cascade do |t|
    t.string "consorcio"
    t.string "sucursal"
    t.string "direccion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "maquinats", force: :cascade do |t|
    t.integer "tipomaquinat_id"
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "serial"
    t.datetime "lastseen"
    t.string "activa"
    t.index ["tipomaquinat_id"], name: "index_maquinats_on_tipomaquinat_id"
  end

  create_table "mixtransaccionests", force: :cascade do |t|
    t.integer "maquinat_id"
    t.string "tipotransaccion"
    t.string "cantidad"
    t.string "comando"
    t.string "status"
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["maquinat_id"], name: "index_mixtransaccionests_on_maquinat_id"
  end

  create_table "postransaccionests", force: :cascade do |t|
    t.string "cantidad"
    t.string "serial"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reportets", force: :cascade do |t|
    t.date "desde"
    t.date "hasta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipomaquinats", force: :cascade do |t|
    t.string "tipomaquina"
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transaccionests", force: :cascade do |t|
    t.integer "maquinat_id"
    t.string "tipotransaccion"
    t.string "cantidad"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "comando"
    t.index ["maquinat_id"], name: "index_transaccionests_on_maquinat_id"
  end

end
