class Customer < ApplicationRecord
  has_many :sales, dependent: :destroy
  has_many :payments, dependent: :destroy
  validates :name, presence: true, length: { minimun: 2, maximum: 50 }
  validates :phone, length: { maximum: 20 }, allow_blank: true

  def balance
    sales.sum(:amount) - payments.sum(:amount)
  end

  def debtor?
    balance > 0
  end
end
