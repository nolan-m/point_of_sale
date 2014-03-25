class DropAddJointable < ActiveRecord::Migration
  def change
    drop_table :items_sales

    create_table :products_sales do |t|
      t.belongs_to :products
      t.belongs_to :sales
    end
  end
end
