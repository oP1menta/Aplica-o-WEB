class Venda < ActiveRecord::Base
  belongs_to :comprador,
             class_name: "Usuario"

  belongs_to :vendedor,
             class_name: "Usuario"
has_many :item_vendas,
         class_name: "ItemVenda",
         foreign_key: :venda_id,
         dependent: :destroy

  validates :status,
            inclusion: {
              in: %w[
                pendente
                paga
                enviada
                entregue
                cancelada
              ]
            }
end