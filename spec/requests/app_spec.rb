require_relative "../spec_helper"

RSpec.describe "RubyLoja" do

  def app
    Sinatra::Application
  end

  it "abre a página de login" do

    get "/login"

    expect(last_response.ok?).to eq(true)

  end

  it "redireciona a raiz para o login" do

    get "/"

    expect(last_response.status).to eq(302)

  end

  it "faz login com sucesso" do

    usuario = Usuario.new(
      nome: "Gabriel",
      email: "gabriel@email.com",
      cpf: "12345678901",
      telefone: "999999999"
    )

    usuario.password = "123456"
    usuario.save

    post "/login", {
      email: "gabriel@email.com",
      senha: "123456"
    }

    expect(last_response.status).to eq(302)

  end

  it "cadastra um usuário" do

    post "/cadastro", {
      nome: "João",
      email: "joao@email.com",
      cpf: "98765432100",
      telefone: "999999999",
      senha: "123456"
    }

    expect(Usuario.count).to eq(1)

  end

end