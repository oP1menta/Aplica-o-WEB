class CreateVendas < ActiveRecord::Migration[8.1]
  def change
    create_table :vendas do |t|
      t.integer :comprador_id
      t.integer :vendedor_id
      t.date :data
      t.string :status
      t.decimal :valor_total  
    end
  end
end
