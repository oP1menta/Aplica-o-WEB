require_relative "../spec_helper"

RSpec.describe Produto do

  before do
    Usuario.delete_all

    @usuario = Usuario.new(
      nome: "Gabriel",
      email: "gabriel@email.com",
      cpf: "12345678901",
      telefone: "999999999"
    )

    @usuario.password = "123456"
    @usuario.save
  end

  it "é válido com dados corretos" do

    produto = Produto.new(
      nome: "Notebook",
      descricao: "Notebook Gamer",
      preco: 3500,
      estoque: 10,
      vendedor_id: @usuario.id
    )

    expect(produto.valid?).to eq(true)

  end

  it "é inválido sem nome" do

    produto = Produto.new(
      nome: "",
      descricao: "Notebook Gamer",
      preco: 3500,
      estoque: 10,
      vendedor_id: @usuario.id
    )

    expect(produto.valid?).to eq(false)

  end

  it "é inválido com preço menor ou igual a zero" do

    produto = Produto.new(
      nome: "Notebook",
      descricao: "Notebook Gamer",
      preco: 0,
      estoque: 10,
      vendedor_id: @usuario.id
    )

    expect(produto.valid?).to eq(false)

  end

  it "é inválido com estoque negativo" do

    produto = Produto.new(
      nome: "Notebook",
      descricao: "Notebook Gamer",
      preco: 3500,
      estoque: -1,
      vendedor_id: @usuario.id
    )

    expect(produto.valid?).to eq(false)

  end

end