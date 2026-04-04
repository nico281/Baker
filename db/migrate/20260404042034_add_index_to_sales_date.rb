class AddIndexToSalesDate < ActiveRecord::Migration[8.0]
  def change
    add_index :sales, :date
  end
end
