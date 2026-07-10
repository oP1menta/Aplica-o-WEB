require_relative "../spec_helper"

RSpec.describe "Compra de Produto", type: :feature do

  it "permite comprar um produto" do

    vendedor = Usuario.new(
      nome: "Vendedor",
      email: "vendedor@email.com",
      cpf: "11111111111",
      telefone: "111111111"
    )

    vendedor.password = "123456"
    vendedor.save

    comprador = Usuario.new(
      nome: "Comprador",
      email: "comprador@email.com",
      cpf: "22222222222",
      telefone: "222222222"
    )

    comprador.password = "123456"
    comprador.save

    Produto.create!(
      nome: "Mouse",
      descricao: "Mouse Gamer",
      preco: 100,
      estoque: 5,
      vendedor_id: vendedor.id
    )

    visit "/login"

    fill_in "email", with: "comprador@email.com"
    fill_in "senha", with: "123456"

    click_button "Entrar"

    click_link "Loja"

    click_link "Ver Detalhes"

    fill_in "quantidade", with: "1"

    click_button "Adicionar ao Carrinho"

    click_button "Finalizar Compra"

    expect(page).to have_content("Carrinho")

  end

end