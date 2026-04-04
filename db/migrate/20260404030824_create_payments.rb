class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :customer, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.date :date
      t.string :notes

      t.timestamps
    end
    add_index :payments, :date
  end
end
