class AddTotalAndQuantity < ActiveRecord::Migration
  def change

    add_column :products_sales, :quantity, :integer
    add_column :products_sales, :total, :numeric, :precision => 8, :scale => 2

    add_column :sales, :total, :numeric, :precision => 8, :scale => 2
  end
end
