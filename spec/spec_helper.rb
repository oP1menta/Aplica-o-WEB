require "rspec"
require "rack/test"
require "capybara/rspec"

ENV["RACK_ENV"] = "test"

require_relative "../app"

ActiveRecord::Base.establish_connection(:test)

Capybara.app = Sinatra::Application

RSpec.configure do |config|

  config.include Rack::Test::Methods

  config.before(:each) do
    ItemVenda.delete_all
    Venda.delete_all
    Produto.delete_all
    Usuario.delete_all
  end

end

def app
  Sinatra::Application
end