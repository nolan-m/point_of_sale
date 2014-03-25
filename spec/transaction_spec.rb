require 'spec_helper'

describe Transaction do
  it 'should create and save information from a transaction including product_id, sale_id, quantity and total' do
    fish = Product.create({:name => 'fish', :price => 5.99})
    test_sale = Sale.create({:cashier_id => 1})
    test_transaction = Transaction.create({:product_id => fish.id, :sale_id => test_sale.id, :quantity => 1, :total => (1 * fish.price)})
    Transaction.all.should eq [test_transaction]
  end

end
