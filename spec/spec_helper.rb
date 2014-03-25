require 'active_record'
require 'shoulda-matchers'
require 'rspec'

require 'product'
require 'cashier'
require 'sale'
require 'transaction'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSpec.configure do |config|
  config.after(:each) do
    Product.all.each { |product| product.destroy }
    Cashier.all.each { |cashier| cashier.destroy }
    Sale.all.each { |sale| sale.destroy }
    Transaction.all.each { |transaction| transaction.destroy }
  end
end
