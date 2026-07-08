require "sinatra"
require "sinatra/activerecord"

set :database_file, "config/database.yml"

get "/" do
  "Loja funcionando!"
end

get "/cadastro" do
  erb :"usuarios/cadastro"
end

get "/login" do
  erb :"usuarios/login"
end