class ItemVenda < ActiveRecord::Base
  self.table_name = "itens_venda"

  belongs_to :venda
  belongs_to :produto

  validates :quantidade,
            numericality: {
              greater_than: 0
            }

  validates :preco_unitario,
            numericality: {
              greater_than: 0
            }
end