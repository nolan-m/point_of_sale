class ChangeCashiersIdInSalesTable < ActiveRecord::Migration
  def change
     change_column(:products, :price, :numeric, :precision => 8, :scale => 2)

     remove_column :sales, :cashiers_id, :integer
     add_column :sales, :cashier_id, :integer
  end
end
