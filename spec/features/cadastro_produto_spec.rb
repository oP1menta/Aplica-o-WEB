require_relative "../spec_helper"

RSpec.describe "Cadastro de Produto", type: :feature do

  it "permite cadastrar um produto" do

    usuario = Usuario.new(
      nome: "Gabriel",
      email: "gabriel@email.com",
      cpf: "12345678901",
      telefone: "999999999"
    )

    usuario.password = "123456"
    usuario.save

    visit "/login"

    fill_in "email", with: "gabriel@email.com"
    fill_in "senha", with: "123456"

    click_button "Entrar"

    click_link "Produtos"

    click_link "Novo Produto"

    fill_in "nome", with: "Notebook"

    fill_in "descricao", with: "Notebook Gamer"

    fill_in "preco", with: "3500"

    fill_in "estoque", with: "10"

    click_button "Salvar"

    expect(page).to have_content("Notebook")

  end

end