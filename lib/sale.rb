class Sale < ActiveRecord::Base
  has_many :products, through: :transaction
  has_many :transactions
end
