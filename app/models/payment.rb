class Payment < ApplicationRecord
  belongs_to :customer
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true

  scope :recent, -> { order(date: :desc) }
end
