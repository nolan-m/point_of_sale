class Product < ActiveRecord::Base
  has_many :sales, through: :transaction
end
