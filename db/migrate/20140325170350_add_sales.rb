class AddSales < ActiveRecord::Migration
  def change
    change_column(:products, :price, :numeric, :precsion => 8, :scale => 2)

    create_table :sales do |t|
      t.belongs_to :cashiers
      t.timestamp
    end

    create_table :items_sales do |t|
      t.belongs_to :items
      t.belongs_to :sales
    end
  end
end
