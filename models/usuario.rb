require "bcrypt"

class Usuario < ActiveRecord::Base
  include BCrypt

  has_many :produtos,
           foreign_key: :vendedor_id

  has_many :compras,
           class_name: "Venda",
           foreign_key: :comprador_id

  has_many :vendas,
           class_name: "Venda",
           foreign_key: :vendedor_id

  validates :nome, presence: true

  validates :cpf, 
            presence: true,
            uniqueness: true

  validates :email,
          presence: true,
          uniqueness: true,
          format: {
            with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/,
            message: "Formatação de email Invalida."
          }

  validates :senha_hash, presence: true

  def password=(senha)
    self.senha_hash = BCrypt::Password.create(senha)
  end

  def authenticate(senha)
    BCrypt::Password.new(senha_hash) == senha
  end
end