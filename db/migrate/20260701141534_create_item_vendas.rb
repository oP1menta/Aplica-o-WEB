class CreateItemVendas < ActiveRecord::Migration[8.1]
  def change
    create_table :itens_venda do |t|
      t.integer :venda_id
      t.integer :produto_id
      t.integer :quantidade
      t.decimal :preco_unitario
    end
  end
end
