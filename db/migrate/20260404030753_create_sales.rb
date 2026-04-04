class CreateSales < ActiveRecord::Migration[8.0]
  def change
    create_table :sales do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :description
      t.decimal :amount, precision: 10, scale: 2
      t.date :date

      t.timestamps
    end
    create_index :sales, :date
  end
end
