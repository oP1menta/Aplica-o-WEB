class CreateUsuarios < ActiveRecord::Migration[8.1]
  def change
    create_table :usuarios do |t|
      t.string :nome
      t.string :email
      t.string :senha_hash
      t.string :cpf
      t.string :telefone
    end
  end
end
