class RenameJoinTable < ActiveRecord::Migration
  def change
    drop_table :products_sales

    create_table :products_sales do |t|
      t.belongs_to :product
      t.belongs_to :sale
    end
  end
end
