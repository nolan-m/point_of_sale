require 'spec_helper'

describe Product do
  it 'creates and saves products' do
    n_product = Product.create({:name => 'Eggs', :price => 2.39})
    Product.all.should eq [n_product]
  end


    it { should have_many :sales }

end
