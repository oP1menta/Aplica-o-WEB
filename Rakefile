require "sinatra/activerecord/rake"
require "./app"

namespace :loja do
  desc "Limpa todos os dados"

  task :limpar do
    ItemVenda.delete_all
    Venda.delete_all
    Produto.delete_all
    Usuario.delete_all

    ActiveRecord::Base.connection.execute(
      "DELETE FROM sqlite_sequence"
    )

    puts "Banco limpo!"
  end
end