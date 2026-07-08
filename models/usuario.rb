require "bcrypt"

class Usuario < ActiveRecord::Base
  include BCrypt

  has_many :produtos, foreign_key: :vendedor_id, dependent: :destroy

  has_many :compras,
           class_name: "Venda",
           foreign_key: :comprador_id

  has_many :vendas,
           class_name: "Venda",
           foreign_key: :vendedor_id

  validates :nome, presence: true

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :cpf, presence: true

  validates :senha_hash, presence: true

  def password=(senha)
    self.senha_hash = Password.create(senha)
  end

  def authenticate(senha)
    Password.new(senha_hash) == senha
  end
end