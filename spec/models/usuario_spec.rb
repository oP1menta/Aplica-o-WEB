require_relative "../spec_helper"

RSpec.describe Usuario do

    before do
        Usuario.delete_all
    end

  it "é válido com dados corretos" do

    usuario = Usuario.new(
      nome: "Gabriel",
      email: "gabriel@email.com",
      cpf: "12345678901",
      telefone: "999999999"
    )

    usuario.password = "123456"

    expect(usuario.valid?).to eq(true)

  end

  it "é inválido sem nome" do

    usuario = Usuario.new(
      nome: "",
      email: "gabriel@email.com",
      cpf: "12345678901",
      telefone: "999999999"
    )

    usuario.password = "123456"

    expect(usuario.valid?).to eq(false)

  end

  it "é inválido sem CPF" do

    usuario = Usuario.new(
      nome: "Gabriel",
      email: "gabriel@email.com",
      cpf: "",
      telefone: "999999999"
    )

    usuario.password = "123456"

    expect(usuario.valid?).to eq(false)

  end

  it "é inválido com email incorreto" do

    usuario = Usuario.new(
      nome: "Gabriel",
      email: "gabriel",
      cpf: "12345678901",
      telefone: "999999999"
    )

    usuario.password = "123456"

    expect(usuario.valid?).to eq(false)

  end

  it "não permite CPF repetido" do

    Usuario.delete_all

    usuario1 = Usuario.new(
      nome: "Gabriel",
      email: "gabriel@email.com",
      cpf: "12345678901",
      telefone: "999999999"
    )

    usuario1.password = "123456"
    usuario1.save

    usuario2 = Usuario.new(
      nome: "João",
      email: "joao@email.com",
      cpf: "12345678901",
      telefone: "888888888"
    )

    usuario2.password = "123456"

    expect(usuario2.valid?).to eq(false)

  end

  it "não permite email repetido" do

    Usuario.delete_all

    usuario1 = Usuario.new(
      nome: "Gabriel",
      email: "gabriel@email.com",
      cpf: "12345678901",
      telefone: "999999999"
    )

    usuario1.password = "123456"
    usuario1.save

    usuario2 = Usuario.new(
      nome: "João",
      email: "gabriel@email.com",
      cpf: "98765432100",
      telefone: "888888888"
    )

    usuario2.password = "123456"

    expect(usuario2.valid?).to eq(false)

  end

end