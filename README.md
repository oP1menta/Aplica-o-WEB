# Loja do Loja

Sistema de loja virtual desenvolvido em Ruby utilizando Sinatra e SQLite.

## Integrantes

- Gabriel Pimenta Bueno
- Pedro Wilson

## Tecnologias

- Ruby
- Sinatra
- ActiveRecord
- SQLite3
- BCrypt
- RSpec
- Capybara

## Funcionalidades

- Cadastro de usuários
- Login e logout
- Edição de perfil
- Cadastro, edição e exclusão de produtos
- Visualização da loja
- Carrinho de compras
- Finalização de compras
- Histórico de compras
- Histórico de vendas
- Controle de estoque
- Atualização do status das vendas
- Cancelamento de compras

## Instalação

Clone o projeto:

```bash
git clone https://github.com/oP1menta/Aplica-o-WEB.git
```

Instale as dependências:

```bash
bundle install
```

## Executando

```bash
ruby app.rb
```

A aplicação ficará disponível em:

```
http://localhost:4567
```

## Executando os testes

```bash
bundle exec rspec
```

## Estrutura do projeto

```
.
├── app.rb
├── models/
├── views/
├── public/
├── spec/
├── db/
└── README.md
```
