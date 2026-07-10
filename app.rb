require "sinatra"
require "sinatra/activerecord"
require "bcrypt"

set :database_file, "config/database.yml"

enable :sessions

Dir["./models/*.rb"].each do |file|
  require file
end

#TESTE/INICIALIZAÇÃO===================
get "/" do
  redirect "/login"
end

#LOGOUT====================
get "/logout" do
  session.clear
  redirect "/login"
end

#CADASTRO===================
get "/cadastro" do
  redirect "/painel" if session[:usuario_id]

  erb :"usuarios/cadastro"
end

post "/cadastro" do
  usuario = Usuario.new(
    nome: params[:nome],
    email: params[:email],
    cpf: params[:cpf].gsub(/\D/, ""),
    telefone: params[:telefone]
  )

  usuario.password = params[:senha]

  if usuario.save
    redirect "/login"
  else
    @usuario = usuario
    erb :"usuarios/cadastro"
  end
end

#LOGIN=======================
get "/login" do
  redirect "/painel" if session[:usuario_id]

  erb :"usuarios/login"
end

post "/login" do
  usuario = Usuario.find_by(email: params[:email])

  if usuario && usuario.authenticate(params[:senha])
    session[:usuario_id] = usuario.id
    redirect "/painel"
  else
    @erro = "E-mail ou senha inválidos."
    erb :"usuarios/login"
  end
end
#LOGIN=======================


#PAINEL======================
get "/painel" do
  redirect "/login" unless session[:usuario_id]

  @usuario = Usuario.find(session[:usuario_id])

  erb :"painel"
end
#PAINEL======================


#PRODUTOS====================
get "/produtos" do
  redirect "/login" unless session[:usuario_id]

  @usuario = Usuario.find(session[:usuario_id])

  @produtos = Produto.where(vendedor_id: @usuario.id)

  @sucesso = session.delete(:sucesso)
  
  erb :"produtos/index"
end

#NOVO PRODUTO====================
get "/produtos/novo" do
  redirect "/login" unless session[:usuario_id]

  erb :"produtos/novo"
end

post "/produtos" do
  redirect "/login" unless session[:usuario_id]

  produto = Produto.new(
    nome: params[:nome],
    descricao: params[:descricao],
    preco: params[:preco],
    estoque: params[:estoque],
    vendedor_id: session[:usuario_id]
  )

  if produto.save
    session[:sucesso] = "Produto cadastrado com sucesso!"
    redirect "/produtos"
  else
    @produto = produto
    erb :"produtos/novo"
  end
end

#EDITAR PRODUTO====================
get "/produtos/:id/editar" do
  redirect "/login" unless session[:usuario_id]

  @produto = Produto.find(params[:id])

  halt 403 if @produto.vendedor_id != session[:usuario_id]

  erb :"produtos/editar"
end

#SALVAR EDIÇÃO====================
post "/produtos/:id" do
  redirect "/login" unless session[:usuario_id]

  produto = Produto.find(params[:id])

  halt 403 if produto.vendedor_id != session[:usuario_id]

  if produto.update(
    nome: params[:nome],
    descricao: params[:descricao],
    preco: params[:preco],
    estoque: params[:estoque]
  )
    redirect "/produtos"
  else
    @produto = produto
    erb :"produtos/editar"
  end
end

#EXCLUIR PRODUTO====================
post "/produtos/:id/excluir" do
  redirect "/login" unless session[:usuario_id]

  produto = Produto.find_by(id: params[:id])
  halt 404, "Produto não encontrado." unless produto

  halt 403 if produto.vendedor_id != session[:usuario_id]

  produto.destroy

  redirect "/produtos"
end


#DETALHES DO PRODUTO====================
get "/produto/:id" do
  redirect "/login" unless session[:usuario_id]

  @produto = Produto.find_by(id: params[:id])

  halt 404 unless @produto

  session[:carrinho] ||= {}

  quantidade_no_carrinho = session[:carrinho][@produto.id.to_s] || 0

  @estoque_disponivel = @produto.estoque - quantidade_no_carrinho

  @erro = session.delete(:erro)

  erb :"loja/produto"
end


#PRODUTOS====================

#LOJA====================
get "/loja" do
  redirect "/login" unless session[:usuario_id]

  @produtos = Produto.where.not(vendedor_id: session[:usuario_id])

  erb :"loja/index"
end



#LOJA=====================



#VENDAS======================
get "/vendas" do
  redirect "/login" unless session[:usuario_id]

  @usuario = Usuario.find(session[:usuario_id])

  @vendas = Venda.where(vendedor_id: @usuario.id)

  erb :"vendas/index"
end

#NOVA VENDA====================
get "/vendas/nova" do
  redirect "/login" unless session[:usuario_id]

  @usuarios = Usuario.where.not(id: session[:usuario_id])
  @produtos = Produto.where(vendedor_id: session[:usuario_id])

  erb :"vendas/nova"
end

#ATUALIZAR STATUS====================
post "/vendas/:id/status" do
  redirect "/login" unless session[:usuario_id]

  venda = Venda.find(params[:id])

  halt 403 unless venda.vendedor_id == session[:usuario_id]

  case venda.status

  when "pendente"
    venda.update(status: "paga")

  when "paga"
    venda.update(status: "enviada")

  when "enviada"
    venda.update(status: "entregue")

  end

  redirect "/vendas-recebidas"
end


#VOLTAR STATUS====================
post "/vendas/:id/voltar-status" do
  redirect "/login" unless session[:usuario_id]

  venda = Venda.find(params[:id])

  halt 403 unless venda.vendedor_id == session[:usuario_id]

  case venda.status
  when "enviada"
    venda.update(status: "paga")

  when "paga"
    venda.update(status: "pendente")
  end

  redirect "/vendas-recebidas"
end


#VENDAS======================

#CARRINHO====================
get "/carrinho" do
  redirect "/login" unless session[:usuario_id]

  session[:carrinho] ||= {}

  @itens = []

  session[:carrinho].each do |produto_id, quantidade|
    produto = Produto.find(produto_id)

    @itens << {
      produto: produto,
      quantidade: quantidade
    }
  end

  erb :"loja/carrinho"
end

post "/carrinho" do
  redirect "/login" unless session[:usuario_id]

  session[:carrinho] ||= {}

  produto_id = params[:produto_id].to_s
  quantidade = params[:quantidade].to_i

  produto = Produto.find(produto_id)

  quantidade_atual = session[:carrinho][produto_id] || 0

  if quantidade_atual + quantidade > produto.estoque
    session[:erro] = "Estoque insuficiente para adicionar essa quantidade ao carrinho."

    redirect "/produto/#{produto.id}"
  end

  session[:carrinho][produto_id] = quantidade_atual + quantidade

  redirect "/carrinho"
end

#FINALIZAR COMPRA====================
post "/finalizar-compra" do
  redirect "/login" unless session[:usuario_id]

  session[:carrinho] ||= {}

  if session[:carrinho].empty?
    session[:erro] = "Seu carrinho está vazio."
    redirect "/carrinho"
  end

  ActiveRecord::Base.transaction do

    primeiro_produto = Produto.find(session[:carrinho].keys.first)

    venda = Venda.create!(
      comprador_id: session[:usuario_id],
      vendedor_id: primeiro_produto.vendedor_id,
      data: Date.today,
      status: "pendente",
      valor_total: 0
    )

    total = 0

    session[:carrinho].each do |produto_id, quantidade|

      produto = Produto.find(produto_id)

      if quantidade > produto.estoque
        raise ActiveRecord::Rollback, "Estoque insuficiente."
      end

      ItemVenda.create!(
        venda_id: venda.id,
        produto_id: produto.id,
        quantidade: quantidade,
        preco_unitario: produto.preco
      )

      produto.update!(
        estoque: produto.estoque - quantidade
      )

      total += produto.preco * quantidade

    end

    venda.update!(
      valor_total: total
    )

  end

  session[:carrinho] = {}

  redirect "/carrinho"
end

#MINHAS COMPRAS====================
get "/minhas-compras" do
  redirect "/login" unless session[:usuario_id]

  @compras = Venda.where(comprador_id: session[:usuario_id])

  erb :"compras/index"
end

#VENDAS RECEBIDAS====================
get "/vendas-recebidas" do
  redirect "/login" unless session[:usuario_id]

  @vendas = Venda.where(vendedor_id: session[:usuario_id])

  erb :"vendas/recebidas"
end

#CANCELAR COMPRA====================
post "/compras/:id/cancelar" do
  redirect "/login" unless session[:usuario_id]

  compra = Venda.find(params[:id])

  halt 403 unless compra.comprador_id == session[:usuario_id]
  halt 400 unless compra.status == "pendente"

  ActiveRecord::Base.transaction do

    compra.item_vendas.each do |item|

      produto = item.produto

      produto.update!(
        estoque: produto.estoque + item.quantidade
      )

    end

    compra.update!(
      status: "cancelada"
    )

  end

  redirect "/minhas-compras"
end

#CARRINHO====================


#PERFIL====================

get "/perfil" do
  redirect "/login" unless session[:usuario_id]

  @usuario = Usuario.find(session[:usuario_id])

  erb :"usuarios/perfil"
end

#ATUALIZAR PERFIL====================
post "/perfil" do
  redirect "/login" unless session[:usuario_id]

  @usuario = Usuario.find(session[:usuario_id])

  if @usuario.update(
    nome: params[:nome],
    email: params[:email],
    telefone: params[:telefone]
  )
    redirect "/painel"
  else
    erb :"usuarios/perfil"
  end
end


#PERFIL====================