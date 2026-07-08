class Produto < ActiveRecord::Base
  belongs_to :vendedor,
             class_name: "Usuario"

  has_many :item_vendas,
         class_name: "ItemVenda",
         foreign_key: :produto_id,
           dependent: :destroy

  validates :nome,
            presence: true

  validates :preco,
            numericality: {
              greater_than: 0
            }

  validates :estoque,
            numericality: {
              greater_than_or_equal_to: 0
            }
end