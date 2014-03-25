class ChangeNameTransactions < ActiveRecord::Migration
  def change
    rename_table(:transaction, :transactions)
  end
end
