require 'spec_helper'

describe Cashier do
  it 'creates and saves products' do
    n_cashier = Cashier.create({:name => 'Nolan', :username => 'nolanm'})
    Cashier.all.should eq [n_cashier]
  end

  it { should have_many :sales }
end
