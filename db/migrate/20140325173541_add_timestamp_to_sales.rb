class AddTimestampToSales < ActiveRecord::Migration
  def change
    add_timestamps(:sales)
  end
end
