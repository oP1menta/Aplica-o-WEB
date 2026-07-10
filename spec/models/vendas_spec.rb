require_relative "../spec_helper"

RSpec.describe Venda do

  before do

    @comprador = Usuario.new(
      nome: "Comprador",
      email: "comprador@email.com",
      cpf: "11111111111",
      telefone: "111111111"
    )

    @comprador.password = "123456"
    @comprador.save

    @vendedor = Usuario.new(
      nome: "Vendedor",
      email: "vendedor@email.com",
      cpf: "22222222222",
      telefone: "222222222"
    )

    @vendedor.password = "123456"
    @vendedor.save

  end

  it "é válida com status pendente" do

    venda = Venda.new(
      comprador_id: @comprador.id,
      vendedor_id: @vendedor.id,
      data: Date.today,
      status: "pendente",
      valor_total: 100
    )

    expect(venda.valid?).to eq(true)

  end

  it "é inválida com status inexistente" do

    venda = Venda.new(
      comprador_id: @comprador.id,
      vendedor_id: @vendedor.id,
      data: Date.today,
      status: "teste",
      valor_total: 100
    )

    expect(venda.valid?).to eq(false)

  end

  it "aceita status paga" do

    venda = Venda.new(
      comprador_id: @comprador.id,
      vendedor_id: @vendedor.id,
      data: Date.today,
      status: "paga",
      valor_total: 100
    )

    expect(venda.valid?).to eq(true)

  end

  it "aceita status entregue" do

    venda = Venda.new(
      comprador_id: @comprador.id,
      vendedor_id: @vendedor.id,
      data: Date.today,
      status: "entregue",
      valor_total: 100
    )

    expect(venda.valid?).to eq(true)

  end

end