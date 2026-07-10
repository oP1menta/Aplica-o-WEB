require_relative "../spec_helper"

RSpec.describe "Login", type: :feature do

  it "permite fazer login" do

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

    expect(page).to have_content("Bem-vindo")

  end

end