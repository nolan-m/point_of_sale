require 'spec_helper'

describe Sale do
  it 'should be created with a sale_id, product_id, date and cashier_id' do
    n_sale = Sale.create({:cashier_id => 1})
    n_sale.cashier_id.should eq 1
  end

  it { should have_many :products }
  it { should have_many :transactions }
end
