class AddIndexToPaymentsDate < ActiveRecord::Migration[8.0]
  def change
    add_index :payments, :date
  end
end
