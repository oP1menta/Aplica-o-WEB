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

#VENDAS======================