class AddTransaction < ActiveRecord::Migration
  def change
    rename_table(:products_sales, :transaction)
  end
end
