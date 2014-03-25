class Cashier < ActiveRecord::Base
  has_many :sales
end
