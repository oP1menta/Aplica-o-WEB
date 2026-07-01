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

ActiveRecord::Schema[8.1].define(version: 2026_07_01_141534) do
  create_table "itens_venda", force: :cascade do |t|
    t.decimal "preco_unitario"
    t.integer "produto_id"
    t.integer "quantidade"
    t.integer "venda_id"
  end

  create_table "produtos", force: :cascade do |t|
    t.string "descricao"
    t.integer "estoque"
    t.string "nome"
    t.decimal "preco"
    t.integer "vendedor_id"
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "cpf"
    t.string "email"
    t.string "nome"
    t.string "senha_hash"
    t.string "telefone"
  end

  create_table "vendas", force: :cascade do |t|
    t.integer "comprador_id"
    t.date "data"
    t.string "status"
    t.decimal "valor_total"
    t.integer "vendedor_id"
  end
end
